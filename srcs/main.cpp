extern "C" {
    #include <mlx.h>
}
#include <iostream>
#include <cstdlib>
#include <math.h>

// Window dimensions
#define WIDTH 800
#define HEIGHT 600

#define ESC_KEY 65307

// Structure to hold MLX data
typedef struct s_data {
    void    *mlx;
    void    *win;
    void    *img;
    char    *addr;
    int     bits_per_pixel;
    int     line_length;
    int     endian;
} t_data;

// Global variable to access data from hook functions
t_data *g_data;

// Function to put pixel in image
void my_mlx_pixel_put(t_data *data, int x, int y, int color)
{
    char *dst;

    dst = data->addr + (y * data->line_length + x * (data->bits_per_pixel / 8));
    *(unsigned int*)dst = color;
}

// Create RGB color from individual components
int create_trgb(int t, int r, int g, int b)
{
    return (t << 24 | r << 16 | g << 8 | b);
}

// Draw gradient effect
void draw_gradient(t_data *data)
{
    int x, y;
    int r, g, b;
    
    for (y = 0; y < HEIGHT; y++)
    {
        for (x = 0; x < WIDTH; x++)
        {
            // Create a diagonal gradient from purple to cyan
            // Calculate color based on position
            r = (255 * x) / WIDTH;                    // Red increases left to right
            g = (255 * y) / HEIGHT;                   // Green increases top to bottom
            b = 255 - ((255 * (x + y)) / (WIDTH + HEIGHT)); // Blue decreases diagonally
            
            // Alternative gradients you can try:
            // Horizontal gradient: r = (255 * x) / WIDTH; g = 128; b = 255 - r;
            // Vertical gradient: r = 255; g = (255 * y) / HEIGHT; b = 128;
            // Radial gradient: see below
            
            int color = create_trgb(0, r, g, b);
            my_mlx_pixel_put(data, x, y, color);
        }
    }
}

// Alternative: Radial gradient function
void draw_radial_gradient(t_data *data)
{
    int x, y;
    int center_x = WIDTH / 2;
    int center_y = HEIGHT / 2;
    double max_distance = sqrt(center_x * center_x + center_y * center_y);
    
    for (y = 0; y < HEIGHT; y++)
    {
        for (x = 0; x < WIDTH; x++)
        {
            double distance = sqrt((x - center_x) * (x - center_x) + (y - center_y) * (y - center_y));
            double ratio = distance / max_distance;
            
            int r = (int)(255 * (1.0 - ratio));  // Red fades from center
            int g = (int)(128 * ratio);          // Green increases from center
            int b = (int)(255 * ratio);          // Blue increases from center
            
            int color = create_trgb(0, r, g, b);
            my_mlx_pixel_put(data, x, y, color);
        }
    }
}

// Handle key press events
int key_press(int keycode, void *param)
{
	(void)param;
    
	if ( keycode == ESC_KEY ) {
		mlx_destroy_window(g_data->mlx, g_data->win);
 		exit( 0 );
	}
	return( 0 ); 
}

// Handle window close button
int close_window()
{
    mlx_destroy_window(g_data->mlx, g_data->win);
    exit(0);
}

int main()
{
    t_data data;
    g_data = &data;

    // Initialize MLX
    data.mlx = mlx_init();
    if (!data.mlx)
    {
        std::cerr << "Error: Failed to initialize MLX" << std::endl;
        return (1);
    }

    // Create a new window
    data.win = mlx_new_window(data.mlx, WIDTH, HEIGHT, (char*)"Gradient Effect");
    if (!data.win)
    {
        std::cerr << "Error: Failed to create window" << std::endl;
        return (1);
    }

    // Create an image
    data.img = mlx_new_image(data.mlx, WIDTH, HEIGHT);
    data.addr = mlx_get_data_addr(data.img, &data.bits_per_pixel, 
                                  &data.line_length, &data.endian);

    // Draw the gradient
    draw_gradient(&data);
    
    // Uncomment this line and comment the above to try radial gradient:
    // draw_radial_gradient(&data);

    // Put the image to window
    mlx_put_image_to_window(data.mlx, data.win, data.img, 0, 0);

    // Set up event handlers
    // mlx_key_hook(data.win, key_press, NULL);
	mlx_hook(data.win, 2, 1L<<0, (int(*)())key_press, NULL);
    mlx_hook(data.win, 17, 1L<<17, close_window, NULL);

    std::cout << "Gradient window opened. Press any key or close button to exit." << std::endl;

    // Start the event loop
    mlx_loop(data.mlx);

    return (0);
}