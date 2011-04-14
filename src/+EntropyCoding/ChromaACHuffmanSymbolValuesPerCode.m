function [ table ] = ChromaACHuffmanSymbolValuesPerCode( )
%ChromaACHuffmanSymbolValuesPerCode Summary of this function goes here
%   Detailed explanation goes here
%
%   +EntropyCoding/ChromaACHuffmanSymbolValuesPerCode.m
%   Part of 'MATLAB Image & Video Compression Demos'
%
%   HELP INFO
%
%   Licensed under the 3-clause BSD license, see 'License.m'
%   Copyright (c) 2011, Stephen Ierodiaconou, University of Bristol.
%   All rights reserved.

%{ 
In Hex
   [00 01 02 03 11 04 05 21 31 06 12 41 51 07 61 71 
    13 22 32 81 08 14 42 91 A1 B1 C1 09 23 33 52 F0 
    15 62 72 D1 0A 16 24 34 E1 25 F1 17 18 19 1A 26 
    27 28 29 2A 35 36 37 38 39 3A 43 44 45 46 47 48 
    49 4A 53 54 55 56 57 58 59 5A 63 64 65 66 67 68 
    69 6A 73 74 75 76 77 78 79 7A 82 83 84 85 86 87 
    88 89 8A 92 93 94 95 96 97 98 99 9A A2 A3 A4 A5 
    A6 A7 A8 A9 AA B2 B3 B4 B5 B6 B7 B8 B9 BA C2 C3 
    C4 C5 C6 C7 C8 C9 CA D2 D3 D4 D5 D6 D7 D8 D9 DA 
    E2 E3 E4 E5 E6 E7 E8 E9 EA F2 F3 F4 F5 F6 F7 F8 
    F9 FA];
%}

% Table ordered by length
table = [ ...
    0 1 ...
    2 ...
    3 17 ...
    4 5 33 49 ...
    6 18 65 81 ...
    7 97 113 ...
    19 34 50 129 ...
    8 20 66 145 161 177 193 ...
    9 35 51 82 240 ...
    21 98 114 209 ...
    10 22 36 52 ...
    ...
    225 ...
    37 241 ...
    23 24 25 26 38 39 40 41 42 53 54 55 56 57 58 67 68 69 70 71 72 73 74 83 84 85 86 87 88 89 90 99 100 101 102 103 104 105 106 115 116 117 118 119 120 121 122 130 131 132 133 134 135 136 137 138 146 147 148 149 150 151 152 153 154 162 163 164 165 166 167 168 169 170 178 179 180 181 182 183 184 185 186 194,195 196 197 198 199 200 201 202 210 211 212 213 214 215 216 217 218 226 227 228 229 230 231 232 233 234 242 243 244 245 246 247 248 249 250];
end
