#include <stdlib.h>

int main(void)
{
    // If you don't use/have Windows Terminal
    system("pwsh yt-dlp.ps1");

    // Firstly call the Windows Terminal.
    // Then before executing any command,
    // open a new tab. Else, it will open
    // the default tab at first and the
    // command will be executed in a another
    // tab. By opening the new tab, Windows
    // Terminal will not open the default tab.
    // system("wt nt pwsh yt-dlp.ps1");
}
