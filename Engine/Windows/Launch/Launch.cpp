#include <iostream>			// cout, cerr
#include <cstdlib>			// EXIT_FAILURE
#include <GL/glew.h>		// GLEW library
#include <GLFW/glfw3.h>	// GLFW library

#include "WoflApp.h"
#include "WoflRenderer.h"

using namespace std; // Uses the standard namespace

// Unnamed namespace
namespace
{
const char* const WINDOW_TITLE = "Neuro System"; // Macro for window title

// Variables for window width and height
const int WINDOW_WIDTH = 1280;
const int WINDOW_HEIGHT = 800;

WoflKeys Keys[400];
	
}


/* User-defined Function prototypes to:
 * initialize the program, set the window size,
 * redraw graphics on the window when resized,
 * and render graphics on the screen
 */
bool UInitialize(int, char*[], GLFWwindow** window);
void UResizeWindow(GLFWwindow* window, int width, int height);
void KeyInputCallback(GLFWwindow* window, int key, int scancode, int action, int mods);
void CharInputCallback(GLFWwindow* window, unsigned int codepoint);
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
	WoflRenderer::Renderer->InitializeAfterWindowCreate(window, WINDOW_WIDTH, WINDOW_HEIGHT);
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
		glfwSwapBuffers(window);	// Flips the the back buffer with the front buffer every frame.
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
	glfwSetKeyCallback(*window, KeyInputCallback);
	glfwSetCharCallback(*window, CharInputCallback);

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

	memset(Keys, 0, sizeof(Keys));
	Keys[GLFW_KEY_ESCAPE] = WoflKeys::Escape;
	Keys[GLFW_KEY_ENTER] = WoflKeys::Enter;
	Keys[GLFW_KEY_BACKSPACE] = WoflKeys::Backspace;
	Keys[GLFW_KEY_SPACE] = WoflKeys::Space;
	Keys[GLFW_KEY_UP] = WoflKeys::UpArrow;
	Keys[GLFW_KEY_DOWN] = WoflKeys::DownArrow;
	Keys[GLFW_KEY_LEFT] = WoflKeys::LeftArrow;
	Keys[GLFW_KEY_RIGHT] = WoflKeys::RightArrow;
	for (int K = 'A'; K <= 'Z'; K++)
	{
		Keys[K] = (WoflKeys)K;
	}
	for (int K = '0'; K <= '9'; K++)
	{
		Keys[K] = (WoflKeys)K;
	}
	for (int K = 0; K < 12; K++)
	{
		Keys[GLFW_KEY_F1 + K] = (WoflKeys)((int)WoflKeys::F1 + K);
	}

	return true;
}

void KeyInputCallback(GLFWwindow* window, int key, int scancode, int action, int mods)
{
	if (action == GLFW_REPEAT)
	{
		return;
	}

	WLOG("key: %d, scancode: %d, action: %d, mods: %d\n", key, scancode, action, mods);

	if (Keys[key] != WoflKeys::None)
	{
		Utils::Input->AddKey(Keys[key], 0, action == GLFW_PRESS ? KeyType::Down : action == GLFW_RELEASE ? KeyType::Up : KeyType::Repeat);
	}
}

void CharInputCallback(GLFWwindow* window, unsigned int codepoint)
{
	WLOG("char: %d\n", codepoint);

	Utils::Input->AddKey(WoflKeys::None, (char)codepoint, KeyType::Down);
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
			Utils::Input->AddTouch(0, (float)PosX, (float)PosY, TouchType::Begin);
			bButtonDown = true;
		}
	}
	else
	{
		if (bButtonDown)
		{
			Utils::Input->AddTouch(0, (float)PosX, (float)PosY, TouchType::End);
			bButtonDown = false;
		}
	}
}


// glfw: whenever the window size changed (by OS or user resize) this callback function executes
void UResizeWindow(GLFWwindow* window, int width, int height)
{
	glViewport(0, 0, width, height);
}

