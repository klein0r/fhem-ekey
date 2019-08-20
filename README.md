# ekey FHEM Module

This module receives UDP requests from ekey home, net or ekey multi LAN adapters on a port of your choice.

## Installation

```
update add https://raw.githubusercontent.com/klein0r/fhem-ekey/master/controls_ekey.txt
update check ekey
update all ekey
```

## Available information

The module splits all available readings in seperate readings automatically. You will get the following information:

### ekey home

Example request: ```1_0046_4_80156809150025_1_2```

- type = ```1```
- user = ```0046```
- finger = ```4```
- scanner = ```80156809150025```
- action = ```1```
- relay = ```2```

### ekey multi

Example request: ```1_0003_-----JOSEF_1_7_2_80156809150025_–GAR_3_-```

- type = ```1```
- user = ```0003```
- user-name = ```JOSEF``` (removes leading dashes)
- user-status = ```1```
- finger = ```7```
- key = ```2```
- scanner = ```80156809150025```
- scanner-name = ```GAR``` (removes leading dashes)
- action = ```3```
- relay = ```-```

### ekey net

Example request: ```1_000001_8_80156809150025_123456```

- type = ```1```
- user = ```000001```
- finger = ```8```
- scanner = ```80156809150025```
- action = ```123456```

## Configuration

See commandref for details

## License

MIT License

Copyright (c) 2019 Matthias Kleine

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
