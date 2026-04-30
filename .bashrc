# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias sb='source ~/.bashrc'
alias gb='gedit ~/.bashrc'
alias cb='cp ~/.bashrc ~/PX4-Autopilot'

alias UPDATE='sudo apt update -y && sudo apt upgrade -y'
alias ga='git add . && git commit -m'

alias memo='gedit ~/PX4-Autopilot/memo'
alias todo='gedit ~/todo'

#alias TURTLE='roslaunch turtlebot3_gazebo turtlebot3_world.launch'
#alias SLAM='roslaunch turtlebot3_slam turtlebot3_slam.launch slam_methods:=gmapping'
#alias NAVIGATION='roslaunch turtlebot3_navigation turtlebot3_navigation.launch'
#alias EXPLORE='roslaunch explore_lite explore.launch'

#alias tftree='rosrun rqt_tf_tree rqt_tf_tree'
alias tftree='cd ~/tftree && ros2 run tf2_tools view_frames && xdg-open $(ls -t frames_*.pdf | head -1)'
#alias base_footprint_to_base_link='rosrun tf static_transform_publisher 0 0 0 0 0 0 base_footprint base_link 100'

# alias kill='pkill -9 px4 && pkill -9 gazebo && pkill -9 gzserver && pkill -9 gzclient && pkill gazebo && pkill gzserver && pkill gzclient'
#alias killgz='pkill -9 gz-sim && pkill -9 ign-gazebo && pkill -9 ign && pkill -9 -f "gz sim" && rm -rf ~/.ignition/gazebo'

killgz() {
    #pkill -9 gz-sim
    #pkill -9 ign-gazebo
    #pkill -9 ign
    pkill -9 -f "gz"
    pkill -9 -f "px4"
    rm -rf ~/.ignition/gazebo
}

#alias killgz2='pkill gzclient'
alias checkgz='ps -ef | grep gz'
alias checkpx4='ps -ef | grep px4'
# alias kill='pkill px4 && pkill gazebo && pkill gzserver && pkill gzclient'
#alias px4_basic='cd ~/PX4-Autopilot && \
#DONT_RUN=1 make px4_sitl_default gazebo-classic && \
#source Tools/simulation/gazebo-classic/setup_gazebo.bash $(pwd) $(pwd)/build/px4_sitl_default && \
#export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$(pwd):$(pwd)/Tools/simulation/gazebo-classic/sitl_gazebo-classic && \
#roslaunch px4 mavros_posix_sitl.launch'
#alias px4='cd ~/PX4-Autopilot && \
#DONT_RUN=1 make px4_sitl_default gazebo-classic && \
#source Tools/simulation/gazebo-classic/setup_gazebo.bash $(pwd) $(pwd)/build/px4_sitl_default && \
#export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$(pwd):$(pwd)/Tools/simulation/gazebo-classic/sitl_gazebo-classic && \
#roslaunch px4 mavros_posix_sitl.launch vehicle:=iris_rplidar world:=$(rospack find mavlink_sitl_gazebo)/worlds/test_zone.world'
alias px4_basic='cd ~/PX4-Autopilot && make px4_sitl gz_x500_lidar_2d'
alias px4_indoor='cd ~/PX4-Autopilot && make px4_sitl gz_x500_lidar_2d_down PX4_GZ_WORLD=husarion_office_empty'
alias px4='cd ~/PX4-Autopilot && make px4_sitl gz_x500_lidar_2d PX4_GZ_WORLD=husarion_office_empty'
alias px4_camera='cd ~/PX4-Autopilot && make px4_sitl gz_x500_depth PX4_GZ_WORLD=walls'
alias dds='MicroXRCEAgent udp4 -p 8888'

alias ftc='cd ~/PX4-Autopilot_FTC && \
DONT_RUN=1 make px4_sitl_default gazebo-classic && \
source Tools/simulation/gazebo-classic/setup_gazebo.bash $(pwd) $(pwd)/build/px4_sitl_default && \
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$(pwd):$(pwd)/Tools/simulation/gazebo-classic/sitl_gazebo-classic && \
roslaunch px4 mavros_posix_sitl.launch'
alias sim_time='ros2 param set /ros_gz_bridge use_sim_time true'
alias mavros='ros2 launch mavros px4.launch fcu_url:="udp://:14540@127.0.0.1:14557" use_sim_time:=true'
alias qgc='~/QGroundControl-x86_64.AppImage'
alias gcs='~/QGroundControl-x86_64.AppImage'

alias offboard="ros2 service call /mavros/set_mode mavros_msgs/srv/SetMode \"{custom_mode: 'OFFBOARD'}\""

#takeoff () {
#  ALT=${1:-2.5}
#
#  # 1. arm
#  ros2 service call /mavros/cmd/arming mavros_msgs/srv/CommandBool "{value: true}"
#
#  # 2. takeoff
#  ros2 service call /mavros/set_mode mavros_msgs/srv/SetMode \
#  "{base_mode: 0, custom_mode: 'AUTO.TAKEOFF'}"
#
#  sleep 10
#
#  # 3. offboard
#  ros2 service call /mavros/set_mode mavros_msgs/srv/SetMode \
#  "{base_mode: 0, custom_mode: 'OFFBOARD'}"
#}

#alias list='rostopic list'
alias list='ros2 topic list'
alias sensor='ros2 launch px4_ros_com sensor_combined_listener.launch.py'
alias sensor2='ros2 topic echo /fmu/out/sensor_combined'
alias imu='ros2 topic echo /mavros/imu/data'
alias pose='ros2 topic echo /mavros/local_position/pose'
alias cmd_vel='ros2 topic echo /mavros/setpoint_velocity/cmd_vel_unstamped'

#alias clock='ros2 run ros_gz_bridge parameter_bridge /clock@rosgraph_msgs/msg/Clock[gz.msgs.Clock'
#alias scan='ros2 run ros_gz_bridge parameter_bridge /scan@sensor_msgs/msg/LaserScan@gz.msgs.LaserScan'
#alias link='ros2 run tf2_ros static_transform_publisher \
#  --x 0 --y 0 --z 0 \
#  --qx 0 --qy 0 --qz 0 --qw 1 \
#  --frame-id base_link \
#  --child-frame-id link'

#lidar () {
#ros2 run ros_gz_bridge parameter_bridge /clock@rosgraph_msgs/msg/Clock[gz.msgs.Clock --ros-args -p use_sim_time:=true &
#ros2 run ros_gz_bridge parameter_bridge /scan@sensor_msgs/msg/LaserScan[gz.msgs.LaserScan --ros-args -p use_sim_time:=true &
#ros2 run tf2_ros static_transform_publisher \
#  --x 0 --y 0 --z 0 \
#  --qx 0 --qy 0 --qz 0 --qw 1 \
#  --frame-id base_link \
#  --child-frame-id link &
#wait
#}

lidar () {
ros2 run ros_gz_bridge parameter_bridge /clock@rosgraph_msgs/msg/Clock[gz.msgs.Clock &
ros2 run ros_gz_bridge parameter_bridge /scan@sensor_msgs/msg/LaserScan[gz.msgs.LaserScan &
ros2 run ros_gz_bridge parameter_bridge /range@sensor_msgs/msg/LaserScan[gz.msgs.LaserScan &
ros2 run tf2_ros static_transform_publisher \
  --x -0.1 --y 0 --z 0.26 \
  --qx 0 --qy 0 --qz 0 --qw 1 \
  --frame-id base_link \
  --child-frame-id link &
ros2 run tf2_ros static_transform_publisher \
  --x 0 --y 0 --z -0.05 \
  --qx 0 --qy 0.7071 --qz 0 --qw 0.7071 \
  --frame-id base_link \
  --child-frame-id lidar_sensor_link &
wait
}

camera () {
ros2 run ros_gz_bridge parameter_bridge /clock@rosgraph_msgs/msg/Clock[gz.msgs.Clock &
ros2 run ros_gz_bridge parameter_bridge /camera/color/image_raw@sensor_msgs/msg/Image@gz.msgs.Image &
ros2 run ros_gz_bridge parameter_bridge /camera/depth/image_raw@sensor_msgs/msg/Image@gz.msgs.Image &
ros2 run ros_gz_bridge parameter_bridge /camera/depth/camera_info@sensor_msgs/msg/CameraInfo@gz.msgs.CameraInfo &
ros2 run depth_image_proc point_cloud_xyz_node --ros-args -r image_rect:=/camera/depth/image_raw -r camera_info:=/camera/depth/camera_info -r points:=/camera/depth/points &
ros2 run tf2_ros static_transform_publisher \
  --x 0 --y 0 --z 0 \
  --qx 0 --qy 0 --qz 0 --qw 1 \
  --frame-id base_link \
  --child-frame-id camera_link &
wait
}

#alias link='ros2 run tf2_ros static_transform_publisher 0 0 0 0 0 0 base_link link --ros-args -p use_sim_time:=true'
#alias lidar='ros2 run tf2_ros static_transform_publisher 0 0 0 0 0 0 base_link link'
#alias laser='ros2 run tf2_ros static_transform_publisher 0 0 0 0 0 0 base_link link'
#alias link='ros2 run tf2_ros static_transform_publisher 0 0 0 0 0 0 base_link link'


alias octomap='ros2 launch scan2pc mapping.launch.py'
#alias octomap='ros2 launch octomap_server octomap_mapping.launch.xml'

#alias planner='ros2 launch ego_planner run_in_gazebo.launch.py'
alias planner='ros2 launch ego_planner run_in_gazebo_depth.launch.py'

alias target="ros2 topic pub --once /move_base_simple/goal geometry_msgs/msg/PoseStamped \"{header: {frame_id: 'odom'}, pose: {position: {x: 20.0, y: 0.0, z: 3.0}, orientation: {w: 1.0}}}\" && ros2 service call /mavros/set_mode mavros_msgs/srv/SetMode \"{custom_mode: 'OFFBOARD'}\""
#target() {
#  ros2 service call /mavros/set_mode mavros_msgs/srv/SetMode "{custom_mode: 'OFFBOARD'}" && \
#  ros2 topic pub --once /move_base_simple/goal geometry_msgs/msg/PoseStamped \
#  "{header: {frame_id: 'odom'}, pose: {position: {x: 20.0, y: 0.0, z: 3.0}, orientation: {w: 1.0}}}"
#}


alias slam='ros2 launch slam_toolbox online_async_launch.py use_sim_time:=true'
#alias slam='ros2 launch ohm_tsd_slam slam.launch.py'

#alias navigation='ros2 launch nav2_bringup navigation_launch.py'
alias navigation='ros2 launch nav2_bringup px4_mavros_navigation_launch.py use_sim_time:=true'

alias exploration='ros2 launch explore_lite explore.launch.py'

alias matlab='cd ~/MATLAB/R2025b/bin && ./matlab'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


source /opt/ros/humble/setup.bash
source ~/ros2_rosgpt/install/setup.bash
source ~/ros2_px4/install/setup.bash
source ~/ros2_mavros/install/setup.bash
source ~/ros2_turtlebot3/install/setup.bash
source ~/ros2_worlds/install/setup.bash
source ~/ros2_slam/install/setup.bash
source ~/ros2_navigation/install/setup.bash
source ~/ros2_exploration/install/setup.bash
source ~/ros2_ego-planner/install/setup.bash
source ~/ros2_rtabmap/install/setup.bash
source ~/ros2_octomap/install/setup.bash
source ~/ros2_scan2pc/install/setup.bash
#source ~/Omni-Drone-260/ros_ws/install/setup.bash

#source ~/catkin_ws/devel/setup.bash

export TURTLEBOT3_MODEL=burger
export TURTLEBOT4_MODEL=standard
export OPENAI_API_KEY=your_api_key
export GZ_SIM_RESOURCE_PATH=~/.gz/models:~/PX4-Autopilot/Tools/simulation/gz/models
export GAZEBO_MODEL_PATH=~/.gz/models
# export GZ_SIM_RESOURCE_PATH=~/ros2_worlds/src/husarion_gz_worlds/worlds:$GZ_SIM_RESOURCE_PATH
export PATH=$PATH:/opt/xtensa-esp-elf/bin/
export PX4_HOME_LAT=47.397742
export PX4_HOME_LON=8.545593
export PX4_HOME_ALT=488.0

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/home/kangmin7/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/home/kangmin7/miniforge3/etc/profile.d/conda.sh" ]; then
#        . "/home/kangmin7/miniforge3/etc/profile.d/conda.sh"
#    else
#        export PATH="/home/kangmin7/miniforge3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
# <<< conda initialize <<<


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
#export MAMBA_EXE='/home/kangmin7/miniforge3/bin/mamba';
#export MAMBA_ROOT_PREFIX='/home/kangmin7/miniforge3';
#__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__mamba_setup"
#else
#    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
#fi
#unset __mamba_setup
# <<< mamba initialize <<<

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

# Cyclone prefers multicast by default, if your router got too much spammed, 
# disable multicast with (https://github.com/ros2/rmw_cyclonedds/issues/489):
export CYCLONEDDS_URI="<Disc><DefaultMulticastAddress>0.0.0.0</></>"

export RCUTILS_LOGGING_USE_STDOUT=1
export RCUTILS_LOGGING_BUFFERED_STREAM=1
# Optional, but if you like colored logs:
export RCUTILS_COLORIZED_OUTPUT=1

