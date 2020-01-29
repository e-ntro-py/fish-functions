function song
    fd -p (echo "$argv" | string replace ' ' '.*')".*.(m4a|mp3|flac|wav)" ~/Music/ | read -z songs
    set n_songs (echo -n "$songs" | wc -l | coln 1)
    if test $n_songs -gt 1
        echo more than 1
        echo -n "$songs"
        echo -n "$songs" | while read -l song
            afplay "$song"
        end
    else
        if test -z "$songs"
            echo empty
        else
            afplay (echo $songs | head -1)
        end
    end
end
