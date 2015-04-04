# Development Environment on Debian
exec { 'apt-update': 
    command=> '/usr/bin/apt-get update'
}

$basepackages = ['tmux', 'strace', 'sudo', 'python', 'netcat', 'tcpdump', 'wireshark', 'tshark', 'htop', 'ltrace', 'vim', 'chromium-browser', 'i3', 'ruby', 'zsh', 'python-pip']
package { $basepackages: 
    ensure => "installed"
}

exec {'pip install': 
    command=> '/usr/bin/pip install -U requests docopt virtualenv dkimpy dnspython httpie tmuxp pymux Django Flask Fabric Markdown'
}
