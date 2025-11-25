<%
import os
files = os.listdir()
context.write(str(context.keys()))
%>

% for f in files:
- ${f}
% endfor