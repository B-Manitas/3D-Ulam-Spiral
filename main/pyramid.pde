class Pyramid extends Projection {
    PShape PYRAMID_SHAPE;
    int PYRAMID_LEVELS = -1;
    
    Pyramid(int s, int mn, PShader shader) {
        this.BOX_SIZE = s;
        this.MAX_NUM = mn;
        this.shader = shader;
    } 
    
    int getTotalBoxes() {
        if (this.PYRAMID_LEVELS == -1)
            this.calculateLevels(N);        
     
        return 1 + 2 * (this.PYRAMID_LEVELS) * (this.PYRAMID_LEVELS - 1);
    }
    
    void calculateLevels(int N) {
        if (N == 0) 
            this.PYRAMID_LEVELS = 0;
        
        else {
            for (this.PYRAMID_LEVELS = 1; this.getTotalBoxes() < N; this.PYRAMID_LEVELS++) {}
            this.PYRAMID_LEVELS--;
        }
    }
    
    void updateShape(int N, int[] px_list, color[] color_list) {
        this.px_list = px_list;
        
        if (this.PYRAMID_LEVELS == -1) {
            this.calculateLevels(N);
            this.generateGraphics(this.BOX_SIZE);
        }
        
        this.updateGraphics(BOX_SIZE, px_list, color_list);
        this.projection_shape = this.generateShape(color_list, N, false);
        this.projection_picking = this.generateShape(color_list, N, true);
    }
    
    PShape generateShape(color[] color_list, int N, boolean isInvisible) {
        PShape pyramid = createShape(GROUP);
        int counter = 1;
        
        for (int i = 0; i < this.PYRAMID_LEVELS; i++) {
            if (i ==  0) 
                pyramid.addChild(this.myPyramidLevelShape(this.BOX_SIZE, i, color_list, this.graphics, this.MAX_NUM, 0, N, isInvisible));
            
            else{
                pyramid.addChild(this.myPyramidLevelShape(this.BOX_SIZE, i, color_list, this.graphics, this.MAX_NUM, counter, N, isInvisible));
                counter += 4 * i;
            }
        }
        return pyramid;
    }
    
    private PShape myPyramidLevelShape(int size, int i, color[] color_list, PGraphics[] textGraphics, int max_num, int counter, int N, boolean isInvisible) {
        PShape pyramid = createShape(GROUP);
        
       	if (i == 0) 
            pyramid.addChild(myBoxShape(color_list, counter, N, true, isInvisible));
    
        else {
            PShape column1 = myPyramidColumnShape(size, i, color_list, textGraphics, max_num, counter, N, isInvisible);
            column1.translate(size * i / 2, size * i / 2, -size * i);
            column1.rotate(PI / 2, 0, 0, -1);
            counter += i;
            pyramid.addChild(column1);
            
            PShape column2 = myPyramidColumnShape(size, i, color_list, textGraphics, max_num, counter, N, isInvisible);
            column2.translate(size * i / 2 - size, -size * i / 2, -size * i);
            counter += i;
            pyramid.addChild(column2);
            
            PShape column3 = myPyramidColumnShape(size, i, color_list, textGraphics, max_num, counter, N, isInvisible);
            column3.translate(size * i / 2 - size, -size * i / 2, -size * i);
            column3.rotate(PI / 2, 0, 0, -1);
            counter += i;
            pyramid.addChild(column3);
            
            PShape column4 = myPyramidColumnShape(size, i, color_list, textGraphics, max_num, counter, N, isInvisible);
            column4.translate(size * i / 2, size * i / 2, -size * i);
            counter += i;
            pyramid.addChild(column4);
        }

        return pyramid;  
    }
    
    private PShape myPyramidColumnShape(int size, int i, color[] color_list, PGraphics[] textGraphics, int max_num, int counter, int N, boolean isInvisible) {
        PShape pyramid = createShape(GROUP);
        for (int j = 0; j < i; j++) {
            PShape box = myBoxShape(color_list, counter, N, true, isInvisible);
            box.translate( - size * j, 0, 0);
            pyramid.addChild(box);
            counter++;
        }
        
        return pyramid;
    }
}
