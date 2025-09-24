Place the images folder to ~/Pictures

Place random-dwall.sh to ~/bin/random-dwall.sh

Place random-dwall.service & random-dwall.timer to ~/.config/systemd/user/

then
systemctl --user enable --now random-dwall.timer
systemctl --user daemon-reload
