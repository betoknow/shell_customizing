#!/bin/bash

# Pfad zur .bashrc-Datei
BASHRC="$HOME/.bashrc"

# Funktion, um Zeilen zu .bashrc hinzuzufügen, falls sie nicht existieren
add_if_not_exists() {
    local line="$1"
    local file="$2"
    grep -qxF -- "$line" "$file" || echo "$line" >> "$file"
}

# Überprüfen und Hinzufügen des Aliases fz, falls nicht vorhanden
alias_line="alias fz=\"fzf --preview 'batcat --style=numbers --color=always --line-range :500 {}'\""
add_if_not_exists "$alias_line" "$BASHRC"

# Überprüfen und Hinzufügen der cd Funktion, falls nicht vorhanden
if ! grep -qxF 'cd() {' "$BASHRC"; then
cat >> "$BASHRC" << 'EOF'

cd() {
    builtin cd "$@" && pwd >> ~/.cd_history
}
EOF
fi

# Überprüfen und Hinzufügen der cf Funktion, falls nicht vorhanden
if ! grep -qxF 'cf() {' "$BASHRC"; then
cat >> "$BASHRC" << 'EOF'

cf() {
    local dir
    dir=$(tac ~/.cd_history | awk '!visited[$0]++' | fzf --height=40% --reverse) && cd "$dir"
}
EOF
fi

# Überprüfen und Hinzufügen der tobin Funktion, falls nicht vorhanden
if ! grep -qxF 'tobin() {' "$BASHRC"; then
cat >> "$BASHRC" << 'EOF'

tobin () {
 local num=$1
 local mask=$((1 << 31)) # Setze die Maske auf das Bit bei Position 31
 for ((i=31; i>=0; i--)); do
   if ((num & mask)); then
     bit=1
   else
     bit=0
   fi
   printf "%02d: %s\n" "$i" "$bit" # Zweistellige Anzeige für die Bitnummer
   mask=$((mask >> 1)) # Verschiebe die Maske um eine Position nach rechts
 done
 echo -n "" # print an empty line to separate the output from the function call
}

EOF
fi

# Überprüfen und Hinzufügen der sun Funktion, falls nicht vorhanden
if ! grep -qxF 'sun() {' "$BASHRC"; then
cat >> "$BASHRC" << 'EOF'
sun() {
python3 << EOF
import datetime
from astral import LocationInfo
from astral.sun import sun
loc = LocationInfo(name='Borchen', region='Germany', timezone='Europe/Berlin', latitude=51.40, longitude=8.44)
current_date = datetime.date.today()
data = sun(loc.observer, date=current_date, tzinfo=loc.timezone)
print(f"Sun data for {loc.name}:")
for key in ['dawn', 'dusk', 'noon', 'sunrise', 'sunset']:
    print(f'{key:10s}: {data[key].strftime("%Y-%m-%d %H:%M:%S")}')
EOF
fi

echo "Die Änderungen wurden vorgenommen."

