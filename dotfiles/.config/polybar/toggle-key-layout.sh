case "$1" in
	"us" )		setxkbmap -layout us;;
	"intl" )	setxkbmap -layout us -variant intl;;
	"" )		:;;
esac

echo "⌨️"
