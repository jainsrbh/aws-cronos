echo "${key_pair_jump}" > /home/${user}/.ssh/id_rsa
chmod 600 /home/${user}/.ssh/id_rsa
chown ${user}:${user} /home/${user}/.ssh/id_rsa

cat <<EOF >> /home/${user}/.ssh/config
Host *
  IdentityFile ~/.ssh/id_rsa
  IdentitiesOnly yes
EOF
chmod 600 /home/${user}/.ssh/config
chown ${user}:${user} /home/${user}/.ssh/config

sudo service sshd restart