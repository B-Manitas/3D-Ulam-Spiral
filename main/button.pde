public enum POSITION {
    INTERIOR, POS_UP, POS_DOWN;
}

class Button {
    int POS_X, POS_Y;
    String text;
    POSITION text_pos;
    
    Button(int posX, int posY, String text, POSITION text_pos) {
        this.POS_X = posX;
        this.POS_Y = posY;
        this.text = text;
        this.text_pos = text_pos;
    }
    
    void bDraw() {
        this.bDraw(#c9c9c9);
    }
    
    void bDraw(color c) {
        stroke(#adadad);
        
        fill(c);
        rect(this.POS_X, this.POS_Y, BUTTON_SIZE_X, BUTTON_SIZE_Y);
        
        fill(0);
        switch(this.text_pos) {
            case INTERIOR : text(this.text, this.POS_X + BUTTON_SIZE_X / 2 - 4, this.POS_Y + BUTTON_SIZE_Y / 2 + 4); break;
            case POS_UP : text(this.text, this.POS_X + BUTTON_SIZE_X / 2 - 5, this.POS_Y - BUTTON_SIZE_Y / 2); break;
            case POS_DOWN : text(this.text, this.POS_X + BUTTON_SIZE_X / 2 - 5, this.POS_Y + BUTTON_SIZE_Y / 2); break;
        }
        
    }
    
    boolean bMousePressed() {
        return(mouseX >= this.POS_X && 
            			mouseX <= this.POS_X + BUTTON_SIZE_X && 
            			mouseY >= this.POS_Y && 
            			mouseY <= this.POS_Y + BUTTON_SIZE_Y);
    }
}
