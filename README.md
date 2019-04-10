# mssy-gateway

| APP_ADDR     | 1               | !!! |
|--------------|-----------------|-----|
|              | gateway je nula |     |
| APP_ENDPOINT | 1 až 12         |     |
| APP_PANID    | 0x4567          |     |


| ID_cmd         | data_size | data |      |
|----------------|-----------|------|------|
| conn           | 128       | 0    | 0    |
| disconn        | 64        | 0    | 0    |
| discovery_req  | 32        | 0    | 0    |
| discovery_resp | 16        | size | data |
| read           | 8         | size | data |
| write          | 4         | size | data |
| read_resp      | 2         | size | data |
| description    | 1         | size | data |


| DEVICE   | PACKET      |     | pro vice  | tresholdu |        |
|----------|-------------|-----|-----------|-----------|--------|
|          | device type | r/w | device ID | data_size | data * |
| keyboard | 255         | r   |           |           |        |
| oled     | 128         | w   |           |           |        |
| mag_cont | 64          | r   |           |           |        |
| relay    | 32          | r/w |           |           |        |
| termo    | 16          | r/w |           |           |        |
| temp     | 10          | r/w |           |           |        |
| press    | 8           | r/w |           |           |        |
| humi     | 6           | r/w |           |           |        |
| motor    | 4           | r/w |           |           |        |
| sleep    | 2           | w   |           |           |        |
| timer    | 1           | r/w |           |           |        |
