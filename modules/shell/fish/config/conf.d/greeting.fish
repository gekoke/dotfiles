function fish_greeting
    neofetch
    printf "\n"
    set_color green; fortune -a | boxes -d java-cmt | lolcat -F 0.05 -S 85
end

