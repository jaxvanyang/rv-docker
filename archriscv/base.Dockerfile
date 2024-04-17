FROM riscfive/archlinux:base

# uncomment all China mirrors and comment out other mirrors
RUN sed -i -E 's/(^Server.*)/#\1/' /etc/pacman.d/mirrorlist && \
	sed -i '/.cn\//s/#//' /etc/pacman.d/mirrorlist
