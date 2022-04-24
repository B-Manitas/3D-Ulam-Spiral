/* PARAMETRES DU PROJET */
final int WIDTH = 1600, HEIGHT = 900;
final int PROJECTION_GAP = 770;
final int PROJECTION_ZOOM = -1000;
final int N = 500;

final int coeff_0 = 0;
final int coeff_1 = 1;
final int coeff_2 = 0;

final int MAX_SPEED_ROTATE = 10;

final int BUTTON_SIZE_X = 30;
final int BUTTON_SIZE_Y = 20;

final int POS_Y_ADD = 10;
final int POS_Y_TEXT = 55;

final int POS_X_ADD_0 = 160;
final int POS_X_ADD_1 = 110;
final int POS_X_ADD_2 = 60;

final int POS_X_ROTATE_SPEED = WIDTH/2 -75;
final int POS_X_TXT_ROT_X = WIDTH /2 - 75+BUTTON_SIZE_X/2;
final int POS_X_TXT_ROT_Y = POS_X_TXT_ROT_X + BUTTON_SIZE_X + 10;
final int POS_X_TXT_ROT_Z = POS_X_TXT_ROT_X + BUTTON_SIZE_X + 50;

final int OFFSET_Y = 60;

final int POS_X_MANUAL_CONTROL = WIDTH - 80;
final int POS_Y_MANUAL_CONTROL = HEIGHT - 70;
final int POS_X_TXT_MANUAL_CONTROL = POS_X_MANUAL_CONTROL - 120;
final int POS_Y_TXT_BOTTOM_SCREEN = POS_Y_MANUAL_CONTROL - 20;

final int POS_X_TXT_CONTROL = 350;

final color NUMBER_0 = #ffffff;
final color NUMBER_1 = #000000;
final color NUMBER_PRIME = #77fc03;
final color NUMBER_DEFICIENT = #ff241c;
final color NUMBER_PERFECT = #1c8eff;
final color NUMBER_ABUNDANT = #ffd21c;
final color NUMBER_SELECTED = #5900ff;
/* FIN DE PARAMETRES */

Model model1, model2;
View view;
Controller controller;

Projection projection1, projection2;
PShader shader;
int highlightBox = 0;

void setup() {
    shader = loadShader("myFragmentShader.glsl", "myVertexShader.glsl");
    size(1600, 900, P3D);
    surface.setTitle("3D Ulam Spiral");

	projection1 = new Pyramid(50, 100, shader);
    projection2 = new Cube(50, shader);
    
    model1 = new Model(N, coeff_2, coeff_1, coeff_0);
    model2 = new Model(N, coeff_2, coeff_1, coeff_0);
    
	view = new View(model1, model2, projection1, projection2);
    controller = new Controller(model1, model2, view);
}

void draw() {
    view.vDraw();
    if (keyPressed) {
      controller.cKeyPressed();
    }
}

void mousePressed() {
    controller.cMousePressed();
}

void keyPressed() {
      controller.cKeyPressedOnce();    
}
