package main

import (
	"log"

	"github.com/agrahafiz13/toku_store_backend/config"
	"github.com/agrahafiz13/toku_store_backend/models"
	"github.com/joho/godotenv"
)

func main() {
	godotenv.Load()
	config.InitDatabase()
	products := []models.Product{
		{
			Name:        "DX Decade Driver",
			Price:       850000,
			Category:    "Kamen Rider",
			Stock:       20,
			Description: "Belt Kamen Rider Decade lengkap dengan kartu",
			ImageURL:    "https://picsum.photos/401",
		},
		{
			Name:        "DX Build Driver",
			Price:       900000,
			Category:    "Kamen Rider",
			Stock:       15,
			Description: "Driver Kamen Rider Build dengan full bottle",
			ImageURL:    "https://picsum.photos/402",
		},
		{
			Name:        "SHF Kamen Rider Kuuga",
			Price:       650000,
			Category:    "Kamen Rider",
			Stock:       25,
			Description: "Figure SHF Kamen Rider Kuuga detail tinggi",
			ImageURL:    "https://picsum.photos/403",
		},
		{
			Name:        "Ultraman Tiga Figure",
			Price:       500000,
			Category:    "Ultraman",
			Stock:       30,
			Description: "Figure Ultraman Tiga poseable",
			ImageURL:    "https://picsum.photos/404",
		},
		{
			Name:        "Ultraman Zero DX Sword",
			Price:       700000,
			Category:    "Ultraman",
			Stock:       18,
			Description: "Pedang Ultraman Zero dengan efek suara",
			ImageURL:    "https://picsum.photos/405",
		},
		{
			Name:        "Ultraman Orb Ring",
			Price:       750000,
			Category:    "Ultraman",
			Stock:       22,
			Description: "Ring transformasi Ultraman Orb",
			ImageURL:    "https://picsum.photos/406",
		},
		{
			Name:        "DX Gokai Cellular",
			Price:       600000,
			Category:    "Super Sentai",
			Stock:       17,
			Description: "Alat transformasi Kaizoku Sentai Gokaiger",
			ImageURL:    "https://picsum.photos/407",
		},
		{
			Name:        "Shuriken Sentai Ninninger Sword",
			Price:       550000,
			Category:    "Super Sentai",
			Stock:       19,
			Description: "Pedang ninja dengan efek suara",
			ImageURL:    "https://picsum.photos/408",
		},
		{
			Name:        "DX Kyuranger Seiza Blaster",
			Price:       800000,
			Category:    "Super Sentai",
			Stock:       14,
			Description: "Blaster utama Kyuranger",
			ImageURL:    "https://picsum.photos/409",
		},
		{
			Name:        "Kamen Rider Geats Magnum Shooter",
			Price:       950000,
			Category:    "Kamen Rider",
			Stock:       12,
			Description: "Senjata Magnum Shooter dari Kamen Rider Geats",
			ImageURL:    "https://picsum.photos/410",
		},
	}
	for _, p := range products {
		config.DB.Create(&p)
	}
	log.Printf("Seed berhasil: %d produk ditambahkan", len(products))
}
