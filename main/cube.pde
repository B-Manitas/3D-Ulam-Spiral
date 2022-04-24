class Cube extends Projection {
    int BOX_NUMBERS = -1;
    int counter = 0;
    int x = 0, y = 0;
    
    Cube(int s, PShader shader) {
        this.BOX_SIZE = s;
        this.shader = shader;
    }
    
    int getTotalBoxes() {
        return floor(pow(this.BOX_NUMBERS, 3) - pow(this.BOX_NUMBERS - 2, 3)) + 2 * this.BOX_NUMBERS + 1;
    }
    
    void calculateBoxNumbers(int N) {
        if (N ==  0) 
            this.BOX_NUMBERS = 0;
        
        else{
            for (this.BOX_NUMBERS = 1; this.getTotalBoxes() < N; this.BOX_NUMBERS++) {}
            this.BOX_NUMBERS--;
        }
    }
    
    void updateShape(int N, int[] px_list, color[] color_list) {
        this.counter = 0;
        this.px_list = px_list;
        
        if (this.BOX_NUMBERS == -1) {
            this.calculateBoxNumbers(N);
            this.MAX_NUM = BOX_NUMBERS * BOX_NUMBERS + 2 * BOX_NUMBERS + 1;
            this.generateGraphics(this.BOX_SIZE);
        }
        
        this.updateGraphics(this.BOX_SIZE, px_list, color_list);
        this.projection_shape = this.generateShape(color_list, N, false);
        this.projection_shape.rotateX(PI);
        this.projection_picking = this.generateShape(color_list, N, true);
        this.projection_picking.rotateX(PI);
    }
    
    PShape generateShape(int[] color_list, int N, boolean isInvisible) {
        this.counter = 0;        
        PShape cube = createShape(GROUP);
        cube.addChild(this.generateSpiralFace(0, color_list, N, isInvisible));
        cube.addChild(this.generateSpiralBorder(color_list, N, isInvisible));
        
        return cube;
    }
    
    private PShape generateLine(int z, int[] color_list, int N, boolean lineToX, int direction, boolean isInvisible) {
        PShape line = createShape(GROUP);
        int for_start = -this.BOX_NUMBERS / 2;
        int for_end = -for_start;
        
        for (int _ = for_start; _ <= for_end; ++_) {
            if (lineToX)
                this.x += direction * this.BOX_SIZE;
            else
                this.y += direction * this.BOX_SIZE;
            
            PShape box = myBoxShape(color_list, this.counter++, N, false, isInvisible);
            box.translate(this.x, this.y, z);
            line.addChild(box);
        }
        
        return line;
    }
    
    private PShape generateSpiralBorder(int[] color_list, int N, boolean isInvisible) {
        PShape border = createShape(GROUP);
        
        for (int k = 1; k <= this.BOX_NUMBERS + 1; k++) {
            int z = k * this.BOX_SIZE;
            border.addChild(generateLine(z, color_list, N, true, 1, isInvisible));
            border.addChild(generateLine(z, color_list, N, false, 1, isInvisible));
            border.addChild(generateLine(z, color_list, N, true, -1, isInvisible));
            border.addChild(generateLine(z, color_list, N, false, -1, isInvisible));
        }
        
        return border;
    }
    
    private PShape generateSpiralFace(int z, int[] color_list, int N, boolean isInvisible) {
        PShape face = createShape(GROUP);
        
        boolean stop = false;
        int count_init = 0;
        
        int state = 0;
        int numSteps = 1, turnCounter = 1;
        
        int x = 0, y = 0;
        
        while(!stop) {   
            count_init++;
            
            PShape box = myBoxShape(color_list, this.counter++, N, false, isInvisible);
            box.translate(x, y, z);
            face.addChild(box);
            
            switch(state) {
                case 0 : x += this.BOX_SIZE; break;
                
                case 1 : y -= this.BOX_SIZE; break;
                
                case 2 : x -= this.BOX_SIZE; break;
                
                case 3 : y += this.BOX_SIZE; break;
            }
            
            if (count_init % numSteps == 0) {
                state = (state + 1) % 4;
                turnCounter++;

                if (turnCounter % 2 == 0) numSteps++;
            }
            
            if (count_init == this.MAX_NUM)
                stop = true;
        }
        
        this.x = x + this.BOX_SIZE;
        this.y = y;
        
        return face;
    }
}
