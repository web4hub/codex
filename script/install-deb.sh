# Fedora 41+
sudo dnf install python3 7zip curl unzip tar rpm-build make gcc-c++ @development-tools

# Fedora < 41
sudo dnf install python3 p7zip p7zip-plugins curl unzip tar rpm-build make gcc-c++
sudo dnf groupinstall 'Development Tools'

# openSUSE
sudo zypper install python3 p7zip-full curl unzip tar
sudo zypper install -t pattern devel_basis

# Arch / Manjaro
sudo pacman -S --needed python p7zip curl unzip tar zstd base-devel

# Rust toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
