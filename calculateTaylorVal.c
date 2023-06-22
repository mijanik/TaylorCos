/***************************** Include Files *********************************/
#include "xil_io.h"
#include "xparameters.h"
#include "taylor_ip.h"

/**************************** user definitions ********************************/

//Taylor processor base addres redefinition
#define TAYLOR_BASE_ADDR      XPAR_TAYLOR_IP_0_S00_AXI_BASEADDR
//Taylor processor registers' offset redefinition
#define CONTROL_REG_OFFSET    TAYLOR_IP_S00_AXI_SLV_REG0_OFFSET
#define ANGLE_REG_OFFSET      TAYLOR_IP_S00_AXI_SLV_REG1_OFFSET
#define STATUS_REG_OFFSET     TAYLOR_IP_S00_AXI_SLV_REG2_OFFSET
#define RESULT_REG_OFFSET    TAYLOR_IP_S00_AXI_SLV_REG3_OFFSET
//Taylor processor bits masks
#define CONTROL_REG_START_MASK (u32)(0x01)
#define STATUS_REG_READY_MASK (u32)(0x01)

// Macors to extract sinus and cosinus values from the accelerator output data register
// Shift left and right to fill msb of int32_t with ones - arithmetic shift  
#define RESULT_REG_COS(param)  ((((s32)param & (s32)0x00FFFFFF)<<8)>>8)
//#define RESULT_REG_COS(param)  ((((s32)param & (s32)0x0FFF0000)<< 4)>>20)


/***************************** calculateTaylorVal function **********************
* The function runs the taylor accelerator IP
* Argument:
* angle - input angle in radians. Fixed-point(12:10) format
* Return values:
* cos - cosinus value. Fixed-point(12:10) format
*
*/

int calculateTaylorVal(u32 angle, s32* cos)
{
u32 data  = angle;
u32 result;

//Debug
//	result = TAYLOR_IP_mReadReg(TAYLOR_BASE_ADDR, RESULT_REG_OFFSET);


//Send data to data register of taylor processor
	TAYLOR_IP_mWriteReg(TAYLOR_BASE_ADDR, ANGLE_REG_OFFSET, data);
//Start taylor processor - pulse start bit in control register
	TAYLOR_IP_mWriteReg(TAYLOR_BASE_ADDR, CONTROL_REG_OFFSET, CONTROL_REG_START_MASK);
	TAYLOR_IP_mWriteReg(TAYLOR_BASE_ADDR, CONTROL_REG_OFFSET, 0);
//Wait for ready bit in status register
	while( (TAYLOR_IP_mReadReg(TAYLOR_BASE_ADDR, STATUS_REG_OFFSET) & STATUS_REG_READY_MASK) == 0);
//Get results
	result = TAYLOR_IP_mReadReg(TAYLOR_BASE_ADDR, RESULT_REG_OFFSET);
//Extract sin and cos from 32-bit register data
	*cos = RESULT_REG_COS( result );
	
	return 1;
}
