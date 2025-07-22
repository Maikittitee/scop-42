extern "C" {
    #include <mlx.h>
}
#include <iostream>
#include <cstdlib>

// Window dimensions
#define WIDTH 800
#define HEIGHT 600

// Structure to hold MLX data
typedef struct s_data {
    void    *mlx;
    void    *win;
} t_data;

// Key codes for common keys
#define ESC_KEY 65307
t_data *g_data;
// Handle key press events
int key_press()
{
    // Since we can't get the keycode, any key will close the window
    // Or we could use a different approach
    mlx_destroy_window(g_data->mlx, g_data->win);
    exit(0);
}

// Handle window close button (X button) - no parameters version
int close_window()
{
    mlx_destroy_window(g_data->mlx, g_data->win);
    exit(0);
}
int main()
{
    t_data data;

    // Initialize MLX
    data.mlx = mlx_init();
    if (!data.mlx)
    {
        std::cerr << "Error: Failed to initialize MLX" << std::endl;
        return (1);
    }

    // Create a new window
    data.win = mlx_new_window(data.mlx, WIDTH, HEIGHT, (char*)"Empty Window");
    if (!data.win)
    {
        std::cerr << "Error: Failed to create window" << std::endl;
        return (1);
    }

    // Set up event handlers
	mlx_hook(data.win, 2, 1L<<0, key_press, &data);            // Key press (KeyPress event)
    mlx_hook(data.win, 17, 1L<<17, close_window, &data);   
    std::cout << "Window opened. Press ESC to close." << std::endl;

    // Start the event loop
    mlx_loop(data.mlx);

    return (0);
}