class Controller {
    Model model1, model2;
    View view;
    
    Controller(Model m1, Model m2, View v) {
        this.model1 = m1;
        this.model2 = m2;
        this.view = v;
    }
    
    void cMousePressed() {
        int coeffA_2_offset = this.view.polyButtonA2.dbMousePressed();
        int coeffA_1_offset = this.view.polyButtonA1.dbMousePressed();
        int coeffA_0_offset = this.view.polyButtonA0.dbMousePressed();
        
        this.model1.update(this.model1.coeff_2 + coeffA_2_offset, 
            			   this.model1.coeff_1 + coeffA_1_offset, 
						   this.model1.coeff_0 + coeffA_0_offset);
        
        int coeffB_2_offset = this.view.polyButtonB2.dbMousePressed();
        int coeffB_1_offset = this.view.polyButtonB1.dbMousePressed();
        int coeffB_0_offset = this.view.polyButtonB0.dbMousePressed();
        
        this.model2.update(this.model2.coeff_2 + coeffB_2_offset, 
						   this.model2.coeff_1 + coeffB_1_offset, 
						   this.model2.coeff_0 + coeffB_0_offset);
        
        // Update the view if a polynomial coeffictient has been changed.
        if (coeffA_2_offset != 0 || coeffA_1_offset != 0 || coeffA_0_offset != 0 || 
            coeffB_2_offset != 0 || coeffB_1_offset != 0 || coeffB_0_offset != 0) {
            
			highlightBox = 0;
			this.view.vUpdate();
        }
        
        // Button : Increase the rotation speed.
        if (this.view.rotationSpeedButton.dbMousePressed() == 1) { 
            this.view.speed_rotate = min(MAX_SPEED_ROTATE, this.view.speed_rotate + 1);
        }
        
        // Button : Decrease the rotation speed.
        if (this.view.rotationSpeedButton.dbMousePressed() == -1) {
            this.view.speed_rotate = max(0, this.view.speed_rotate - 1);
        }
        
        // Button : Rotation X.
        if (this.view.radioButtonX.bMousePressed()) { 
            this.view.is_rotate_x = this.switchValueRadio(this.view.is_rotate_x);
        }
        
        // Button : Rotation Y.
        if (this.view.radioButtonY.bMousePressed()) { 
            this.view.is_rotate_y = this.switchValueRadio(this.view.is_rotate_y);
        }
        
        // Button : Rotation Z.
        if (this.view.radioButtonZ.bMousePressed()) { 
            this.view.is_rotate_z = this.switchValueRadio(this.view.is_rotate_z);
        }
        
        if (this.view.manualButton.bMousePressed()) { 
            this.view.automatic = this.switchValueRadio(this.view.automatic);
        }
        
        // Button : Zoom
        if(this.view.projectionZoom.dbMousePressed() == -1){
            this.view.projection_zoom = min(-500, this.view.projection_zoom + 100);
        }

        if(this.view.projectionZoom.dbMousePressed() == 1){
            this.view.projection_zoom = max(-1500, this.view.projection_zoom - 100);
        }

       	// Picking
		int pixel1 = this.view.graphics1.get(mouseX, mouseY);
		int pixel2 = this.view.graphics2.get(mouseX, mouseY);
        
		if (pixel1 != 0) {
			int n = this.computeCounter(pixel1);
			highlightBox = highlightBox == n ? 0 : n;	
			this.view.vUpdate();
		}
        
		if (pixel2 != 0) {
			int n = this.computeCounter(pixel2);
			highlightBox = highlightBox == n ? 0 : n;			
			this.view.vUpdate();
		}
        
       	if (this.view.pickerButton.dbMousePressed() == -1) {
			--highlightBox;
			this.view.vUpdate();
        }
        
        if (this.view.pickerButton.dbMousePressed() == 1) {
			++highlightBox;
			this.view.vUpdate();
        }
	}
    
    void cKeyPressedOnce(){
        if (key == ' ') 
            this.view.automatic = switchValueRadio(this.view.automatic);
        
        if (key == 'r') 
            this.view.reset();
    }

    void cKeyPressed() {
        if(this.view.automatic == 0) {
            if (key == CODED) {
                if (keyCode == UP) {
                    this.view.angle2X -= this.view.speed_rotate / 20f;
    	        }
        
		        else if (keyCode == DOWN) {
                    this.view.angle2X += this.view.speed_rotate / 20f;
        	    }
            
			    else if (keyCode == LEFT) {
                    this.view.angle2Y += this.view.speed_rotate / 20f;
            	}
                
				else if (keyCode == RIGHT) {
                    this.view.angle2Y -= this.view.speed_rotate / 20f;
            	}
        	}
        
			else {
				if (key == 'z') {
					this.view.angle1X -= this.view.speed_rotate / 20f;
				}

				else if (key == 's') {
					this.view.angle1X += this.view.speed_rotate / 20f;
				}
				
				else if (key == 'q') {
					this.view.angle1Y += this.view.speed_rotate / 20f;
				}
				
				else if (key == 'd') {
					this.view.angle1Y -= this.view.speed_rotate / 20f;
				}
			}
    	}
	}
    
    int switchValueRadio(int value) {
        return value == 1 ? 0 : 1;
    }
    
    int computeCounter(int pixel) {
		return int(red(pixel) + green(pixel) * 256 + blue(pixel) * 256 * 256 - 1);
	}
}
