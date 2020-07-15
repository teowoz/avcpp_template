#include <avcpp/av.h>
#include <avcpp/format.h>
#include <avcpp/formatcontext.h>
#include <avcpp/codec.h>
#include <avcpp/codeccontext.h>
#include <avcpp/videorescaler.h>
#include <avcpp/audioresampler.h>
#include <iostream>
#include <vector>

int main(int argc, char** argv) {
    if (argc<2) {
        std::cerr << "Please specify input!\n";
        return 1;
    }
    std::string url = argv[1];
    
    av::init();
    av::set_logging_level(AV_LOG_VERBOSE);
    
    av::FormatContext inctx;
    inctx.openInput(url);
    inctx.findStreamInfo();
    
    
    /* process the input here */
    
    
    return 0;
}
