class View {
    Model model1, model2;
    public Projection projection1, projection2;
    public PGraphics graphics1, graphics2;

    int projection_zoom = PROJECTION_ZOOM;
    int speed_rotate = MAX_SPEED_ROTATE / 2;
	int is_rotate_x = 1;
    int is_rotate_y = 1;
    int is_rotate_z = 1;
    
    float angle1X = 0;
    float angle1Y = 0;
    float angle1Z = 0;
    
    float angle2X = 0;
    float angle2Y = 0;
    float angle2Z = 0;
    
    int automatic = 0;

    RotationButton radioButtonX, radioButtonY, radioButtonZ;
    DoubleButton polyButtonA2, polyButtonA1, polyButtonA0;
    DoubleButton polyButtonB2, polyButtonB1, polyButtonB0;
    DoubleButton rotationSpeedButton;
    
    RotationButton manualButton;
    DoubleButton pickerButton;
    DoubleButton projectionZoom;

    View(Model m1, Model m2, Projection p1, Projection p2) {
        this.model1 = m1;
        this.model2 = m2;

        this.projection1 = p1;
        this.projection2 = p2;

        this.graphics1 = createGraphics(1600, 900, P3D);
        this.graphics2 = createGraphics(1600, 900, P3D);
        
		this.polyButtonA2 = new DoubleButton(POS_X_ADD_2, POS_Y_ADD);
        this.polyButtonA1 = new DoubleButton(POS_X_ADD_1, POS_Y_ADD);
		this.polyButtonA0 = new DoubleButton(POS_X_ADD_0, POS_Y_ADD);

        this.polyButtonB2 = new DoubleButton(width - POS_X_ADD_0, POS_Y_ADD);
        this.polyButtonB1 = new DoubleButton(width - POS_X_ADD_1, POS_Y_ADD);
        this.polyButtonB0 = new DoubleButton(width - POS_X_ADD_2, POS_Y_ADD);
        
		this.rotationSpeedButton = new DoubleButton(POS_X_ROTATE_SPEED, POS_Y_TEXT - BUTTON_SIZE_Y, true);

		this.radioButtonX = new RotationButton(POS_X_TXT_ROT_X, POS_Y_ADD + OFFSET_Y, "X");
        this.radioButtonY = new RotationButton(POS_X_TXT_ROT_Y, POS_Y_ADD + OFFSET_Y, "Y");
        this.radioButtonZ = new RotationButton(POS_X_TXT_ROT_Z, POS_Y_ADD + OFFSET_Y, "Z");
        
        this.manualButton = new RotationButton(POS_X_MANUAL_CONTROL, POS_Y_MANUAL_CONTROL, "");
        this.pickerButton = new DoubleButton(POS_X_TXT_MANUAL_CONTROL, POS_Y_MANUAL_CONTROL + 30, true);
		this.projectionZoom = new DoubleButton(POS_X_TXT_MANUAL_CONTROL - 160, POS_Y_MANUAL_CONTROL + 30, true);

		this.vUpdate();
    }

    void vDraw() {
        background(255);
        
        fill(0);
		// The text polynome for model 1. 
		text("P(X) = ", 10, POS_Y_TEXT);
        this.polyButtonA2.dbDraw(this.model1.coeff_2 + "X²+");
        this.polyButtonA1.dbDraw(this.model1.coeff_1 + "X+");
        this.polyButtonA0.dbDraw(str(this.model1.coeff_0));
        
		// The text polynome for model 2. 
		text("P(X) = ", width - 10 - POS_X_ADD_0 - 40, POS_Y_TEXT);
        this.polyButtonB2.dbDraw(this.model2.coeff_2 + "X²+");
        this.polyButtonB1.dbDraw(this.model2.coeff_1 + "X+");
        this.polyButtonB0.dbDraw(str(this.model2.coeff_0));
        
		// The rotation controller text.
        text("ROTATION CONTROLLER", POS_X_ROTATE_SPEED, POS_Y_ADD + BUTTON_SIZE_Y / 2);
        this.radioButtonX.bDrawActive(this.is_rotate_x);
        this.radioButtonY.bDrawActive(this.is_rotate_y);
        this.radioButtonZ.bDrawActive(this.is_rotate_z);
        this.rotationSpeedButton.dbDraw("speed : " + speed_rotate * 100 / MAX_SPEED_ROTATE + "%");

        text("LEGENDE", 10, POS_Y_TXT_BOTTOM_SCREEN);
        createRectLegend(10, POS_Y_TXT_BOTTOM_SCREEN + 10, NUMBER_0, "0");
        createRectLegend(10, POS_Y_TXT_BOTTOM_SCREEN + 28, NUMBER_1, "1");
        createRectLegend(10, POS_Y_TXT_BOTTOM_SCREEN + 46, NUMBER_PRIME, "Prime");
        createRectLegend(100, POS_Y_TXT_BOTTOM_SCREEN + 10, NUMBER_DEFICIENT, "Deficient");
        createRectLegend(100, POS_Y_TXT_BOTTOM_SCREEN + 28, NUMBER_PERFECT, "Perfect");
        createRectLegend(100, POS_Y_TXT_BOTTOM_SCREEN + 46, NUMBER_ABUNDANT, "Abundant");
        createRectLegend(210, POS_Y_TXT_BOTTOM_SCREEN + 10, NUMBER_SELECTED, "Highlight");
        
        text("KEY CONTROL", POS_X_TXT_CONTROL, POS_Y_TXT_BOTTOM_SCREEN - 10);
        text("[-] z, q, s, d : rotate pyramid", POS_X_TXT_CONTROL, POS_Y_TXT_BOTTOM_SCREEN + 10 + 13);
        text("[-] arrows : rotate cube", POS_X_TXT_CONTROL, POS_Y_TXT_BOTTOM_SCREEN + 28 + 13);
        text("[-] space : dis/enabled manual control", POS_X_TXT_CONTROL, POS_Y_TXT_BOTTOM_SCREEN + 46 + 13);
        text("[-] r : reset all", POS_X_TXT_CONTROL + 260, POS_Y_TXT_BOTTOM_SCREEN + 10 + 13);
        text("[-] mouse cliked : picking", POS_X_TXT_CONTROL + 260, POS_Y_TXT_BOTTOM_SCREEN + 28 + 13);

        text("MANUAL CONTROL", POS_X_TXT_MANUAL_CONTROL, POS_Y_MANUAL_CONTROL + 14);
        this.manualButton.bDrawActive(this.automatic == 0 ? 1 : 0);
        this.pickerButton.dbDraw("pick n° " + highlightBox);
        this.projectionZoom.dbDraw("zoom : " + 1.*this.projection_zoom/PROJECTION_ZOOM);

		// SHADER SHAPE FOR MODEL 1.
        this.graphics1.loadPixels() ;
        this.graphics1.beginDraw();
        this.graphics1.pushMatrix();
        this.graphics1.translate(width / 2 - PROJECTION_GAP, height / 2, this.projection_zoom);
        
        this.angle1X += automatic * is_rotate_x * this.speed_rotate / 100.;
        this.angle1Y += automatic * is_rotate_y * this.speed_rotate / 100.;
        this.angle1Z += automatic * is_rotate_z * this.speed_rotate / 100.;
        
        this.graphics1.rotateX(this.angle1X);
        this.graphics1.rotateY(this.angle1Y);
        this.graphics1.rotateZ(this.angle1Z);
        
        this.graphics1.shader(this.projection1.getShader());
        this.graphics1.shape(this.projection1.getShapePicking(), 0, 0);      
        this.graphics1.resetShader();

		this.graphics1.popMatrix();
        this.graphics1.endDraw();

		// COLORED SHAPE FOR MODEL 1.
        pushMatrix();
        translate(width / 2 - PROJECTION_GAP, height / 2, this.projection_zoom);        
        
        rotateX(this.angle1X);
        rotateY(this.angle1Y);
        rotateZ(this.angle1Z);

        shape(this.projection1.getShape(), 0, 0);
		popMatrix();
        
		// SHADER SHAPE FOR MODEL 2.
        this.graphics2.loadPixels() ;
        this.graphics2.beginDraw();
        this.graphics2.pushMatrix();
        this.graphics2.translate(width / 2 + PROJECTION_GAP, height / 2, this.projection_zoom);
        
        this.angle2X += automatic * is_rotate_x * this.speed_rotate / 100.;
        this.angle2Y += automatic * is_rotate_y * this.speed_rotate / 100.;
        this.angle2Z += automatic * is_rotate_z * this.speed_rotate / 100.;
        
        this.graphics2.rotateX(this.angle2X);
        this.graphics2.rotateY(this.angle2Y);
        this.graphics2.rotateZ(this.angle2Z);
        
        this.graphics2.shader(this.projection2.getShader());
        this.graphics2.shape(this.projection2.getShapePicking(), 0, 0);        
        this.graphics2.resetShader();

		this.graphics2.popMatrix();
        this.graphics2.endDraw();

		// COLORED SHAPE FOR MODEL 2.
        pushMatrix();
        translate(width / 2 + PROJECTION_GAP, height / 2, this.projection_zoom);
                
        rotateX(this.angle2X);
        rotateY(this.angle2Y);
        rotateZ(this.angle2Z);

		shape(this.projection2.getShape(), 0, 0);
        
		popMatrix();
    }
    
    void vUpdate() {
        this.projection1.updateShape(this.model1.N, this.model1.px_list, this.model1.color_list);
        this.projection2.updateShape(this.model2.N, this.model2.px_list, this.model2.color_list);
    }

    void reset(){
        this.automatic = 0;
        this.is_rotate_x = 1;
        this.is_rotate_y = 1;
        this.is_rotate_z = 1;

        this.projection_zoom = PROJECTION_ZOOM;
        this.speed_rotate = MAX_SPEED_ROTATE / 2;

        this.angle1X = 0;
        this.angle1Y = 0;
        this.angle1Z = 0;
        
        this.angle2X = 0;
        this.angle2Y = 0;
        this.angle2Z = 0;

        highlightBox = 0;

        this.model1.update(0, 1, 0);
        this.model2.update(0, 1, 0);        
        this.vUpdate();
    }

    void createRectLegend(int x, int y, color colorRect, String text){
        fill(colorRect);
        rect(x, y, 15, 15);
        fill(0);
        text(text, x + 20, y + 13);
    }
}
