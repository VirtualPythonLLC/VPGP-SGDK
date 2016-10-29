#include <genesis.h>

int main()
{
	VDP_drawText("Hello World Sega Genesis!!!", 9, 10);

	while(1)
	{
		VDP_waitVSync();
	}
	return (0);
}
