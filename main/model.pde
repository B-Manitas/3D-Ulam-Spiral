class Model {
    int N;
    int coeff_2 = 0, coeff_1 = 0, coeff_0 = 0;
    int[] px_list;
    color[] color_list;
    
    Model(int n, int coeff_2, int coeff_1, int coeff_0) {
        this.N = n;
        this.update(coeff_2, coeff_1, coeff_0);
    }
    void update(int coeff_2, int coeff_1, int coeff_0) {
        if (this.coeff_2 != coeff_2 || this.coeff_1 != coeff_1 || this.coeff_0 != coeff_0) {
            this.coeff_2 = coeff_2;
            this.coeff_1 = coeff_1;
            this.coeff_0 = coeff_0;
            this.update();
        }
    }

    void update() {
        this.px_list = this.secDegPolynomial(this.coeff_2, this.coeff_1, this.coeff_0, this.N);
        this.color_list = this.getColorsList(this.px_list);
    }
    
    int sumDivider(int n) {
        int r = n + 1;
        
        for (int d = 2; d <= sqrt(n); d++)
            if (n % d ==  0) 
            {
                r += d;

                int c = n/d;
                if (c != d) 
                    r += c;
            }
        
        return r;
    }
    
    color getColors(int n) {
        n = abs(n);

        if (n == 0)
            return NUMBER_0;

        else if (n ==  1)
            return NUMBER_1;
        
        else{
            int sum = this.sumDivider(n);
            
            if (sum == n + 1)
                return NUMBER_PRIME;
            
            else if (sum < 2 * n)
                return NUMBER_DEFICIENT;
            
            else if (sum == 2 * n) 
                return NUMBER_PERFECT;
            
            else
                return NUMBER_ABUNDANT;
        }
    }
    
    int[] secDegPolynomial(int a2, int a1, int a0, int N) {
        int[] list = new int[N];
        
        for (int x = 1; x <= N; ++x) 
            list[x - 1] = a0 + a1 * x + a2 * x * x;
        
        return list;
    }
    
    color[] getColorsList(int[] px_list) {
        color[] color_list = new color[this.N];
        
        for (int i = 0; i < this.N; i++) 
            color_list[i] = this.getColors(px_list[i]);
        
        return color_list;
    }
}
