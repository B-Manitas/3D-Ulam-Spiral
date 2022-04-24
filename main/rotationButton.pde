class RotationButton extends Button {
    RotationButton(int posX, int posY, String text) {
        super(posX, posY, text, POSITION.INTERIOR);
    }

    void bDrawActive(int is_active) {
		if (is_active == 1) 
			this.bDraw(#00FF00);
		
		else
			this.bDraw(#FF0000);
    }
}
