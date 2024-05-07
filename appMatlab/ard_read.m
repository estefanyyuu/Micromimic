clear, clc, clf, close all

% port = serialportlist("available");
s = serialport("COM3",9600);
flush(s)

% d = readline(s);
n=1;

while true
    data = readline(s)
end