package main

import (
	"flag"
	"fmt"
	"math/rand"
	"os"
	"os/exec"
	"path/filepath"
	"time"
)

var (
	// Define the interval flag (default is 3600 seconds)
	intervalFlag = flag.Int("interval", 3600, "Interval in seconds between wallpaper changes")
	lockFile     = "/tmp/wallpaper_cycle.lock"
)

func getImages(path string) ([]string, error) {
	var images []string
	extensions := map[string]bool{".jpg": true, ".png": true, ".webp": true, ".jpeg": true}

	err := filepath.Walk(path, func(p string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if !info.IsDir() && extensions[filepath.Ext(p)] {
			images = append(images, p)
		}
		return nil
	})
	return images, err
}

func changeWallpaper(imgsMain, imgsSide []string) {
	// Skip if LockFile exists (Gaming Mode)
	if _, err := os.Stat(lockFile); err == nil {
		fmt.Println("Wallpaper swhitch is paused")
		return
	}

	// Random selection from memory
	m := imgsMain[rand.Intn(len(imgsMain))]
	s := imgsSide[rand.Intn(len(imgsSide))]

	// Apply wallpapers via swww
	// 60 FPS keeps transitions smooth without spiking GPU usage
	cmdMain := exec.Command("swww", "img", "-o", "DP-1", m, "--transition-type", "random", "--transition-fps", "60", "--transition-step", "90")
	cmdSide := exec.Command("swww", "img", "-o", "DP-3", s, "--transition-type", "random", "--transition-fps", "60", "--transition-step", "90", "--resize", "stretch")

	_ = cmdMain.Run()
	_ = cmdSide.Run()

	fmt.Printf("[%s] Wallpapers updated: %s | %s\n", time.Now().Format("15:04:05"), filepath.Base(m), filepath.Base(s))
}

func main() {
	// 1. Parse command-line flags
	flag.Parse()

	duration := time.Duration(*intervalFlag) * time.Second
	fmt.Printf("Starting Wallpaper Manager. Interval set to: %v\n", duration)

	home, _ := os.UserHomeDir()
	wallMain := filepath.Join(home, ".config/hypr/wallpapers/main")
	wallSide := filepath.Join(home, ".config/hypr/wallpapers/side")

	for exec.Command("swww", "query").Run() != nil {
		fmt.Fprintf(os.Stderr, "[%s] Error: Waiting for swww-daemon...\n", time.Now().Format("15:04:05"))
		time.Sleep(5 * time.Second)
	}

	fmt.Println("swww-daemon is running! Proceeding...")

	// 3. Image scan
	imgsMain, errM := getImages(wallMain)
	imgsSide, errS := getImages(wallSide)

	if errM != nil || errS != nil || len(imgsMain) == 0 || len(imgsSide) == 0 {
		fmt.Fprintln(os.Stderr, "Error: No images found in the specified directories.")
		os.Exit(1)
	}

	// Immediate execution for startup
	changeWallpaper(imgsMain, imgsSide)

	// Main loop with Ticker (Efficient CPU sleep)
	ticker := time.NewTicker(duration)
	defer ticker.Stop()

	for range ticker.C {
		changeWallpaper(imgsMain, imgsSide)
	}
}
