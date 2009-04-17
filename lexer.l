%{
#define YY_NO_UNPUT

int token_begin_loc, token_end_loc;
  
#define YY_USER_ACTION { token_begin_loc = token_end_loc; token_end_loc += yyleng; }
%}

%%
\==           return 1;
\+            return 1;
\=            return 1;
\&\&            return 1;
\|\|            return 1;
\-            return 1;
\if           return 1;
emit          return 1;
return          return 1;

\'.*\'         return 2;
\".*\"         return 2;

function      return 3;


\/\/.*           return 4;


.
\n

<<EOF>>   {
            yy_delete_buffer(YY_CURRENT_BUFFER);
            return 0;
          }
%%
