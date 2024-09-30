# Install the required APT packages.
sudo apt install --assume-yes \
  pipx \
  fonts-roboto \
  flatpak \
  gnome-software-plugin-flatpak

# Add Flathub Flatpak repository.
flatpak remote-add --if-not-exists flathub \
  https://dl.flathub.org/repo/flathub.flatpakrepo

# Install the required Flatpak packages.
flatpak install --assumeyes flathub com.brave.Browser
flatpak install --assumeyes flathub org.onlyoffice.desktopeditors

# Add ~/.local/bin to environment variables.
pipx ensurepath
export PATH=$PATH:~/.local/bin

# Install RobotoMono Nerd Font.
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.0/RobotoMono.zip
sudo mkdir -p /usr/share/fonts/truetype/roboto-mono-nerd
sudo unzip -o RobotoMono.zip -d /usr/share/fonts/truetype/roboto-mono-nerd
sudo fc-cache -fv
rm -v RobotoMono.zip

# Install adw-gtk3 GTK3 theme.
adw_gtk3_url=$(curl -s https://api.github.com/repos/lassekongo83/adw-gtk3/releases/latest | jq --raw-output '.assets[0] | .browser_download_url')
curl -LO "$adw_gtk3_url"
adw_gtk3_file_path=$(find . -name '*.tar.xz')
sudo tar -xvf "$adw_gtk3_file_path" -C /usr/share/themes
rm -v "$adw_gtk3_file_path"

# Install gnome-extensions-cli.
pipx install gnome-extensions-cli --system-site-packages

# Change the permissions of GNOME Shell extensions directory temporarily.
sudo chmod 777 -R /usr/share/gnome-shell/extensions

# Install GNOME Shell extensions.
gnome_shell_extension_ids=(
  1160 # Dash to Panel
  3628 # ArcMenu
  2087 # Desktop Icons NG (DING)
  517  # Caffeine
  1319 # GSConnect
  4099 # No overview at start-up
)
for id in "${gnome_shell_extension_ids[@]}"; do
  gext --filesystem install $id
done
echo "Extensions installed."

# Restore the permissions of GNOME Shell extensions directory.
sudo chmod 755 -R /usr/share/gnome-shell/extensions

# Download the wallpaper.
wallpaper_url="https://initiate.alphacoders.com/download/images5/979813/png"
wallpaper_output_file_path="/usr/share/wallpapers/979813.png"
sudo wget -O "${wallpaper_output_file_path}" "${wallpaper_url}"
echo "Wallpaper saved to ${wallpaper_output_file_path}."

# Apply Rin GNOME Shell configuration.
dconf load -f / <rin.dconf
echo "Rin installed."
