class DoubleButton {
    Button plus, minus;
    String text;
    
    int posX;
    int pos_text_y;
    
    DoubleButton(int posX, int posY) {
        this.plus = new Button(posX, posY, "+", POSITION.INTERIOR);
        this.minus = new Button(posX, posY + OFFSET_Y, "-", POSITION.INTERIOR);
        this.posX = posX + 3;
        this.pos_text_y = posY + BUTTON_SIZE_Y / 2 + OFFSET_Y / 2 + 5;
    }
    
    DoubleButton(int posX, int posY, boolean horizontal) {
        if (horizontal) {
            this.minus = new Button(posX, posY, "-", POSITION.INTERIOR);
            this.plus = new Button(posX + 2 * OFFSET_Y, posY, "+", POSITION.INTERIOR);
            this.posX = posX + BUTTON_SIZE_X + 10;
            this.pos_text_y = posY + 3 * BUTTON_SIZE_Y / 4;
        }
        
        else{
            this.plus = new Button(posX, posY, "+", POSITION.INTERIOR);
            this.minus = new Button(posX, posY + OFFSET_Y, "-", POSITION.INTERIOR);
            this.posX = posX + 3;
            this.pos_text_y = posY + BUTTON_SIZE_Y / 2 + OFFSET_Y / 2 + 5;    
        } 
    }
    
    void dbDraw(String text) {
        this.plus.bDraw();
        this.minus.bDraw();
        fill(0);
        text(text, this.posX, this.pos_text_y);
    }
    
    int dbMousePressed() {
        if (this.plus.bMousePressed()) 
            return 1;
        
        else if (this.minus.bMousePressed()) 
            return -1;
        
        else
            return 0;
    }
}
