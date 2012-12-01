struct SlapInfo;
void* initCanvas();
void setPerseverance(void* canvas,int perseverance);
SlapInfo* slapShape(void* canvas,unsigned int *pixels, int width, int height);
int getStatus(void* canvas);
void setStatus(void* canvas,int status);
double getShrinkage(void* canvas);
void appendLayer(void* canvas,unsigned int *pixels, unsigned int *colorPixels, int width, int height,bool flip);
