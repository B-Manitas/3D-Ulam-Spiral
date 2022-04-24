abstract class Projection {
    int BOX_SIZE;
    float NB_TOTAL_BOX;
    int MAX_NUM;
    int[] px_list;

    PGraphics[] graphics;
    PShader shader;
    PShape projection_shape;
    PShape projection_picking;
    
    abstract int getTotalBoxes();
    abstract PShape generateShape(int[] color_list, int N, boolean isInvisible);
    abstract void updateShape(int N, int[] px_list, color[] color_list);

    PShader getShader(){
        return this.shader; 
    }

    PShape getShape() { 
        return this.projection_shape; 
    }
    
    PShape getShapePicking() { 
        return this.projection_picking; 
    }

    void generateGraphics(int size) {
        this.graphics = new PGraphics[this.MAX_NUM];
    
        for (int i = 0; i < this.MAX_NUM; i++) 
            this.graphics[i] = createGraphics(size, size, P3D);
    }
    
    void updateGraphics(int size, int[] px_list, color[] color_list) {
        float r = size / 2.;
        for (int i = 0; i < this.MAX_NUM; i++) {
            this.graphics[i].beginDraw();
            this.graphics[i].background(color_list[i]);
            this.graphics[i].textSize(20);
            this.graphics[i].fill(0);
            this.graphics[i].textAlign(CENTER);
            this.graphics[i].text(px_list[i], r, r);
            this.graphics[i].endDraw();
        }
    }

    PShape myBoxShape(int size, PGraphics pg, color bg_color, int counter, boolean rotateY) {
        PShape box = createShape();

        if (rotateY) 
            box.rotateY(PI);

        box.beginShape(QUADS);

        float r = size / 2.;
        
        if (highlightBox == counter)
            box.fill(NUMBER_SELECTED);

        else if (pg != null)
            box.texture(pg);
        
        else
            box.fill(bg_color);
                
        box.vertex( -r, -r, -r, size, 0);
        box.vertex( -r, -r, r, size, size);
        box.vertex( -r, r, r, 0, size);
        box.vertex( -r, r, -r, 0, 0);

        box.vertex( -r, r, -r, 0, 0);
        box.vertex(r, r, -r, size, 0);
        box.vertex(r, -r, -r, size, size);
        box.vertex( -r, -r, -r, 0, size);
        
        box.vertex(r, -r, -r, size, 0);
        box.vertex(r, -r, r, size, size);
        box.vertex( -r, -r, r, 0, size);
        box.vertex( -r, -r, -r, 0, 0);
        
        box.vertex(r, r, r, size, size);
        box.vertex(r, -r, r, 0, size);
        box.vertex(r, -r, -r, 0, 0);
        box.vertex(r, r, -r, size, 0);
        
        box.vertex(r, r, r, size, 0);
        box.vertex( -r, r, r, size, size);
        box.vertex( -r, -r, r, 0, size);
        box.vertex(r, -r, r, 0, 0);
        
        box.vertex(r, r, r, 0, size);
        box.vertex(r, r, -r, 0, 0);
        box.vertex( -r, r, -r, size, 0);
        box.vertex( -r, r, r, size, size);
        
        box.endShape(QUADS);
        
        return box;
    }

    PShape myBoxShapePicking(int counter){
        float r = this.BOX_SIZE / 2.;

        PShape box = createShape();
        box.beginShape(QUADS);    
        box.noStroke();

        int n = counter+1;
        int N0 = n % 256;
        int N1 = ((n - N0) / 256) % 256;
        int N2 = ((n - N0 - N1) * 256 / 256 * 256) % 256;

        box.attrib("vert_color", N0/255.0, N1/255.0, N2/255.0, 1.0);
        box.vertex( -r, -r, -r, this.BOX_SIZE, 0);
        box.vertex( -r, -r, r, this.BOX_SIZE, this.BOX_SIZE);
        box.vertex( -r, r, r, 0, this.BOX_SIZE);
        box.vertex( -r, r, -r, 0, 0);

        box.vertex( -r, r, -r, 0, 0);
        box.vertex(r, r, -r, this.BOX_SIZE, 0);
        box.vertex(r, -r, -r, this.BOX_SIZE, this.BOX_SIZE);
        box.vertex( -r, -r, -r, 0, this.BOX_SIZE);
        
        box.vertex(r, -r, -r, this.BOX_SIZE, 0);
        box.vertex(r, -r, r, this.BOX_SIZE, this.BOX_SIZE);
        box.vertex( -r, -r, r, 0, this.BOX_SIZE);
        box.vertex( -r, -r, -r, 0, 0);
        
        box.vertex(r, r, r, this.BOX_SIZE, this.BOX_SIZE);
        box.vertex(r, -r, r, 0, this.BOX_SIZE);
        box.vertex(r, -r, -r, 0, 0);
        box.vertex(r, r, -r, this.BOX_SIZE, 0);
        
        box.vertex(r, r, r, this.BOX_SIZE, 0);
        box.vertex( -r, r, r, this.BOX_SIZE, this.BOX_SIZE);
        box.vertex( -r, -r, r, 0, this.BOX_SIZE);
        box.vertex(r, -r, r, 0, 0);
        
        box.vertex(r, r, r, 0, this.BOX_SIZE);
        box.vertex(r, r, -r, 0, 0);
        box.vertex( -r, r, -r, this.BOX_SIZE, 0);
        box.vertex( -r, r, r, this.BOX_SIZE, this.BOX_SIZE);
        
        box.endShape(QUADS);

        
        return box;
    }

    PShape myBoxShape(color[] bg_color, int counter, int N, boolean rotateY, boolean isInvisible) {
        stroke(0);

        if (isInvisible)
            return myBoxShapePicking(this.px_list[counter]);

        else if (counter < this.MAX_NUM) 
            return myBoxShape(this.BOX_SIZE, this.graphics[counter], bg_color[counter], this.px_list[counter], rotateY);

        else if (counter < N) 
            return myBoxShape(this.BOX_SIZE, null, bg_color[counter], this.px_list[counter], rotateY);

        else 
            return myBoxShape(this.BOX_SIZE, null, #FFFFFF, this.px_list[counter], rotateY);
    }
}
