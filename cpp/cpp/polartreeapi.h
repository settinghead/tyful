struct SlapInfo;
void* initCanvas();
void setPerseverance(void* canvas,int perseverance);
void feedShape(void* canvas,unsigned int *pixels, int width, int height, unsigned int sid);
int getStatus(void* canvas);
void setStatus(void* canvas,int status);
double getShrinkage(void* canvas);
void appendLayer(void* canvas,unsigned int *pixels, unsigned int *colorPixels, int width, int height,bool flip);
void startRendering(void* canvas);