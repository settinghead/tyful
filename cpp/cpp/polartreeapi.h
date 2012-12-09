struct SlapInfo;
struct Dimension;
void initCanvas();
void setPerseverance(int perseverance);
void feedShape(unsigned int *pixels, int width, int height, unsigned int sid,bool flip, bool rgbaToArgb);
int getStatus();
void setStatus(int status);
double getShrinkage();
void appendLayer(unsigned int *pixels, unsigned int *colorPixels, int width, int height,bool flip,bool rgbaToArgb);
void appendLayer(unsigned char *png, size_t png_size);
void updateTemplate(unsigned int *data);
void loadTemplateFromZip(unsigned char *data);
unsigned char * getZipFromTemplate();
void feedShape(unsigned int *data);
void startRendering();
void pauseRendering();
SlapInfo* getNextSlap();
SlapInfo* tryNextShape();
SlapInfo* slapShape(unsigned int *pixels, int width, int height,unsigned int sid);
unsigned int getNumberOfPendingShapes();
Dimension getCanvasSize();
void resetFixedShapes();
void setFixedShape(int sid, int x, int y, double rotation);