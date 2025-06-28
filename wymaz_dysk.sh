#!/bin/bash

# --- Konfiguracja ---
# Przejście na Pulpit
cd ~/Desktop
# Prefiks dla plików tymczasowych
PREFIX_PLIKU="tymczasowy_plik_do_wymazania"

# --- Funkcja do sprzątania po anulowaniu (Ctrl+C) lub na koniec ---
function cleanup() {
    echo -e "\n\n[INFO] Rozpoczynam sprzątanie..."
    # Użycie gwiazdki (*) do usunięcia wszystkich pasujących plików
    rm -f ${PREFIX_PLIKU}_*.tmp
    echo "[INFO] Wszystkie pliki tymczasowe zostały usunięte."
}

# --- Pułapka na sygnał przerwania ---
# Uruchomi funkcję cleanup() po naciśnięciu Ctrl+C
trap cleanup SIGINT SIGTERM

# --- Główna część skryptu ---
echo "------------------------------------------------------------------"
echo "ETAP 1: Zapełnianie wolnej przestrzeni dyskowej."
echo "Skrypt będzie tworzył pliki 2GB i 4GB aż do zapełnienia dysku."
echo "Aby anulować w dowolnym momencie, naciśnij: Ctrl+C"
echo "------------------------------------------------------------------"

# Licznik do tworzenia unikalnych nazw plików
i=1
# Pętla, która będzie działać aż do zapełnienia dysku
while true; do
    # Logika do naprzemiennego wybierania rozmiaru 2GB lub 4GB
    if (( i % 2 != 0 )); then
        rozmiar_gb=2
    else
        rozmiar_gb=4
    fi

    # Tworzenie unikalnej nazwy pliku dla każdej iteracji
    PLIK_TYMCZASOWY="${PREFIX_PLIKU}_${i}.tmp"
    
    echo "[INFO] Tworzenie pliku nr $i: '$PLIK_TYMCZASOWY' (Rozmiar: ${rozmiar_gb}GB)..."
    
    # Tworzenie pliku o zadanym rozmiarze
    dd if=/dev/zero of="$PLIK_TYMCZASOWY" bs=1g count=$rozmiar_gb &>/dev/null
    
    # Sprawdzenie, czy komenda 'dd' się powiodła. Jeśli nie (kod błędu różny od 0), oznacza to brak miejsca.
    if [ $? -ne 0 ]; then
        echo -e "\n[SUKCES] Dysk został zapełniony. Przechodzę do etapu usuwania plików."
        # Usuwamy ostatni, nie w pełni utworzony plik przed wyjściem z pętli
        rm -f "$PLIK_TYMCZASOWY"
        break # Wyjście z pętli 'while'
    fi
    
    # Zwiększenie licznika na potrzeby następnego pliku
    i=$((i+1))
done

echo "------------------------------------------------------------------"
echo "ETAP 2: Usuwanie wszystkich plików tymczasowych."
# Wywołanie funkcji sprzątającej, aby usunąć wszystkie utworzone pliki
cleanup
echo "------------------------------------------------------------------"
echo "[ZAKOŃCZONO] Wolna przestrzeń dyskowa została pomyślnie wymazana."