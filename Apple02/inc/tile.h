

// current read buffer
extern u8* tileRead;
// current write buffer
extern u8* tileWrite;


void tile_init();

u16 tile_unpack();

void unpack_dico0(u8* buf);
void unpack_dico1(u8* buf);
void unpack_dico2(u8* buf);

void unpack_plain_and_pix(u8* buf);
void unpack_derive(u8* buf, u8* prev, u16 extra);
void unpack_copy(u8* buf, u8* prev);
void unpack_raw(u8* buf);

void log_(u8* dst);
