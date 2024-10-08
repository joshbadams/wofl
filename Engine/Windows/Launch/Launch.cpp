#include <iostream>         // cout, cerr
#include <cstdlib>          // EXIT_FAILURE
#include <GL/glew.h>        // GLEW library
#include <GLFW/glfw3.h>     // GLFW library

#include "WoflApp.h"
#include "WoflRenderer.h"

using namespace std; // Uses the standard namespace

// Unnamed namespace
namespace
{
const char* const WINDOW_TITLE = "Tutorial 2.2"; // Macro for window title

// Variables for window width and height
const int WINDOW_WIDTH = 800;
const int WINDOW_HEIGHT = 600;
    
}


/* User-defined Function prototypes to:
 * initialize the program, set the window size,
 * redraw graphics on the window when resized,
 * and render graphics on the screen
 */
bool UInitialize(int, char*[], GLFWwindow** window);
void UResizeWindow(GLFWwindow* window, int width, int height);
void UProcessInput(GLFWwindow* window);


// main function. Entry point to the OpenGL program
int main(int argc, char* argv[])
{
    // Main GLFW window
    GLFWwindow* window = nullptr;

    if (!UInitialize(argc, argv, &window))
        return EXIT_FAILURE;

    // Sets the background color of the window to black (it will be implicitely used by glClear)
    //glClearColor(0.0f, 0.0f, 0.0f, 1.0f);

    //so the background is red instead of black.
    glClearColor(1.0f, 0.0f, 0.0f, 1.0f);

    WoflApplication::InitializePlatform();
    WoflRenderer::Renderer->InitializeAfterWindowCreate(WINDOW_WIDTH, WINDOW_HEIGHT);
    WoflApplication::InitializeAndCreateGame();


    // render loop
    // -----------
    while (!glfwWindowShouldClose(window))
    {
		// input
		// -----
		UProcessInput(window);

		glClear(GL_COLOR_BUFFER_BIT);

		WoflApplication::Tick();
		WoflApplication::Render();

		// glfw: swap buffers and poll IO events (keys pressed/released, mouse moved etc.)
		glfwSwapBuffers(window);    // Flips the the back buffer with the front buffer every frame.
		glfwPollEvents();
		glFlush();
    }

    exit(EXIT_SUCCESS); // Terminates the program successfully
}


// Initialize GLFW, GLEW, and create a window
bool UInitialize(int argc, char* argv[], GLFWwindow** window)
{
    // GLFW: initialize and configure (specify desired OpenGL version)
    // ------------------------------
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 4);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

#ifdef __APPLE__
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
#endif

    // GLFW: window creation
    // ---------------------
    *window = glfwCreateWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE, NULL, NULL);
    if (*window == NULL)
    {
        std::cout << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
        return false;
    }
    glfwMakeContextCurrent(*window);
    glfwSetFramebufferSizeCallback(*window, UResizeWindow);

    // GLEW: initialize
    // ----------------
	//// Note: if using GLEW version 1.13 or earlier
	glewExperimental = GL_TRUE;
	GLenum GlewInitResult = glewInit();

    if (GLEW_OK != GlewInitResult)
    {
        std::cerr << glewGetErrorString(GlewInitResult) << std::endl;
        return false;
    }

    // Displays GPU OpenGL version
    cout << "INFO: OpenGL Version: " << glGetString(GL_VERSION) << endl;

    return true;
}


// process all input: query GLFW whether relevant keys are pressed/released this frame and react accordingly
void UProcessInput(GLFWwindow* window)
{
	//if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
	//{
	//	glfwSetWindowShouldClose(window, true);
	//}


	static bool bButtonDown = false;
	int ButtonState = glfwGetMouseButton(window, GLFW_MOUSE_BUTTON_LEFT);
	double PosX, PosY;
	glfwGetCursorPos(window, &PosX, &PosY);
	if (ButtonState == GLFW_PRESS)
	{
		if (!bButtonDown)
		{
			Utils::Input->AddTouch(0, PosX, PosY, TouchType::Begin);
			bButtonDown = true;
		}
	}
	else
	{
		if (bButtonDown)
		{
			Utils::Input->AddTouch(0, PosX, PosY, TouchType::End);
			bButtonDown = false;
		}
	}
}


// glfw: whenever the window size changed (by OS or user resize) this callback function executes
void UResizeWindow(GLFWwindow* window, int width, int height)
{
    glViewport(0, 0, width, height);
}

