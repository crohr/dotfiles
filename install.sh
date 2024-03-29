#!/bin/bash
set -ex
set -o pipefail

MY_USER=crohr
MY_HOME=/home/$MY_USER

sed -i "s|PasswordAuthentication yes|PasswordAuthentication no|" /etc/ssh/sshd_config
sshd -t
service ssh restart

id $MY_USER || useradd -d $MY_HOME --shell /bin/bash -m $MY_USER
echo 'crohr    ALL = NOPASSWD: ALL' > /etc/sudoers.d/crohr
mkdir -p $MY_HOME/.ssh
chmod 0700 $MY_HOME/.ssh
curl -L https://github.com/crohr.keys -o $MY_HOME/.ssh/authorized_keys
chmod 0600 $MY_HOME/.ssh/authorized_keys
chown -R crohr:crohr $MY_HOME/.ssh

workspace=$(mktemp -d)

apt-get update -qq
apt-get install -y \
	apt-transport-https \
	ca-certificates \
	curl \
	software-properties-common \
	libpq-dev \
	postgresql \
	redis-server \
	snapd \
	jq \
	htop \
	vim \
	git \
	ntp \
	sudo \
	wget \
	tmux \
	lsof \
	bash-completion \
	cron \
	git-crypt

snap install ngrok

su - postgres -c "psql -c \"create role dev with superuser login password 'p4ssw0rd'\""

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) \
	 stable"

# virtualbox
#echo 'deb http://download.virtualbox.org/virtualbox/debian yakkety contrib' > /etc/apt/sources.list.d/virtualbox.list
#wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -

apt-get update -qq
apt-get install -y \
	docker-ce \
	rcm
	# virtualbox-dkms \
	# virtualbox

getent group docker || groupadd docker
usermod -aG docker $MY_USER

# Install vagrant
# LATEST_VAGRANT_URL=$(curl -s https://releases.hashicorp.com/vagrant/index.json \
#     | jq --raw-output \
#         '.versions
#         | with_entries(select(.key | test("-rc[0-9]+$") | not))
#         | to_entries
#         | max_by(.key)
#         | .value.builds[]
#         | select(.arch=="x86_64")
#         | select(.os=="debian")
#         | .url')
#
# curl "$LATEST_VAGRANT_URL" -o $workspace/vagrant.deb
# dpkg -i $workspace/vagrant.deb

# outside of su so that we can use ssh agent forwarding
test -d $MY_HOME/.dotfiles || git clone git@github.com:crohr/dotfiles $MY_HOME/.dotfiles
GIT_DIR=$MY_HOME/.dotfiles/.git git pull origin master
chown -R $MY_USER:$MY_USER $MY_HOME/.dotfiles

rm -rf $workspace

su -l $MY_USER -c "
mkdir -p ~/dev
rm -rf $MY_HOME/.vim/bundle/Vundle.vim
git clone https://github.com/gmarik/Vundle.vim.git $MY_HOME/.vim/bundle/Vundle.vim
rcup -x install.sh
vim +PluginInstall +qall
#echo 'Host *
#  PubkeyAcceptedKeyTypes=+ssh-dss' > $MY_HOME/.ssh/config
"

# install asdf - http://asdf-vm.com
# asdf plugin add nodejs
# asdf plugin add ruby

# bundle config --global jobs $(nproc)

# After that, move over the following private stuff:
# .gnupg/
# .aws/
# .docker/
# .netrc
# .vpn/
# .ngrok2/
