module top_module(
  input clk,          //positive edge
  input reset,        //active high, walks left
  input bump_left,    //bumping to left side of the wall
  input bump_right,   //bumping to right side of the wall
  input ground,       //1 represents ground is available
  input dig,          //signal to  indicate to dig the ground
  output walk_left,   //indicates walking left
  output walk_right,  //indicates walking right
  output aaah,        //indicates falling
  output digging      //indicates digging the ground
  ); 

  // states
  reg [2:0] current_state,next_state;
  parameter LEFT=0,RIGHT=1,DIG_L=2,DIG_R=3,FALL_L=4,FALL_R=5,SPLAT=6;
  
  // counter to count the number of clock cycles in falling state
  reg [7:0] count;

  // counter logic
  always@(posedge clk, posedge areset)
  begin
    if(areset)
      count<=0;
    else if(next_state == FALL_L | next_state == FALL_R)
      count<=count+8'd1;
    else
      count<=0;
  end

  // current state logic
  always@(posedge clk, posedge areset)
  begin
    if(areset)
      current_state<=LEFT;
    else
      current_state<=next_state;
  end

  always@(*)
  begin
    case(current_state)
      LEFT:
        begin
          case({bump_left,ground,dig})
            3'b110:next_state<=RIGHT;
            3'b011:next_state<=DIG_L;
            3'b111:next_state<=DIG_L;
            3'b000:next_state<=FALL_L;
            3'b001:next_state<=FALL_L;
            3'b100:next_state<=FALL_L;
            3'b101:next_state<=FALL_L;
            default:next_state<=LEFT;
          endcase
        end
      RIGHT:
        begin
          case({bump_right,ground,dig})
            3'b110:next_state<=LEFT;
            3'b011:next_state<=DIG_R;
            3'b111:next_state<=DIG_R;
            3'b000:next_state<=FALL_R;
            3'b001:next_state<=FALL_R;
            3'b100:next_state<=FALL_R;
            3'b101:next_state<=FALL_R;
            default:next_state<=RIGHT;
          endcase
        end
      DIG_L:
        begin
          next_state<=ground?DIG_L:FALL_L;
        end
      DIG_R:
        begin
          next_state<=ground?DIG_R:FALL_R;
        end
      FALL_L:
        begin
          if(ground)
          begin
            if(count>20)
              next_state<=SPLAT;
            else
              next_state<=LEFT;
          end
          else
            next_state<=FALL_L;
        end
      FALL_R:
        begin
          if(ground)
          begin
            if(count>20)
              next_state<=SPLAT;
            else
              next_state<=RIGHT;
          end
          else
            next_state<=FALL_R;
        end
      SPLAT:
        begin
          next_state<=SPLAT;
        end
    endcase
  end

  assign walk_left = (current_state == LEFT);
  assign walk_right = (current_state == RIGHT);
  assign aaah = (current_state == FALL_L) | (current_state == FALL_R);
  assign digging = (current_state == DIG_L) | (current_state == DIG_R);
endmodule