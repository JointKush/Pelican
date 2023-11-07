
//Created by Action Script Viewer - http://www.buraks.com/asv
    class com.gskinner.geom.ColorMatrix extends Array
    {
        var join, slice;
        function ColorMatrix (p_matrix) {
            super();
            p_matrix = fixMatrix(p_matrix);
            copyMatrix(((p_matrix.length == LENGTH) ? (p_matrix) : (IDENTITY_MATRIX)));
        }
        function adjustColor(p_brightness, p_contrast, p_saturation, p_hue) {
            adjustHue(p_hue);
            adjustContrast(p_contrast);
            adjustBrightness(p_brightness);
            adjustSaturation(p_saturation);
        }
        function adjustBrightness(p_val) {
            p_val = cleanValue(p_val, 100);
            if ((p_val == 0) || (isNaN(p_val))) {
                return(undefined);
            }
            multiplyMatrix([1, 0, 0, 0, p_val, 0, 1, 0, 0, p_val, 0, 0, 1, 0, p_val, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);
        }
        function adjustContrast(p_val) {
            p_val = cleanValue(p_val, 100);
            if ((p_val == 0) || (isNaN(p_val))) {
                return(undefined);
            }
            var _local2;
            if (p_val < 0) {
                _local2 = 127 + ((p_val / 100) * 127);
            } else {
                _local2 = p_val % 1;
                if (_local2 == 0) {
                    _local2 = DELTA_INDEX[p_val];
                } else {
                    _local2 = (DELTA_INDEX[p_val << 0] * (1 - _local2)) + (DELTA_INDEX[(p_val << 0) + 1] * _local2);
                }
                _local2 = (_local2 * 127) + 127;
            }
            multiplyMatrix([_local2 / 127, 0, 0, 0, 0.5 * (127 - _local2), 0, _local2 / 127, 0, 0, 0.5 * (127 - _local2), 0, 0, _local2 / 127, 0, 0.5 * (127 - _local2), 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);
        }
        function adjustSaturation(p_val) {
            p_val = cleanValue(p_val, 100);
            if ((p_val == 0) || (isNaN(p_val))) {
                return(undefined);
            }
            var _local2 = 1 + ((p_val > 0) ? ((3 * p_val) / 100) : (p_val / 100));
            var _local5 = 0.3086;
            var _local4 = 0.6094;
            var _local6 = 0.082;
            multiplyMatrix([(_local5 * (1 - _local2)) + _local2, _local4 * (1 - _local2), _local6 * (1 - _local2), 0, 0, _local5 * (1 - _local2), (_local4 * (1 - _local2)) + _local2, _local6 * (1 - _local2), 0, 0, _local5 * (1 - _local2), _local4 * (1 - _local2), (_local6 * (1 - _local2)) + _local2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);
        }
        function adjustHue(p_val) {
            p_val = (cleanValue(p_val, 180) / 180) * Math.PI;
            if ((p_val == 0) || (isNaN(p_val))) {
                return(undefined);
            }
            var _local3 = Math.cos(p_val);
            var _local2 = Math.sin(p_val);
            var _local5 = 0.213;
            var _local4 = 0.715;
            var _local6 = 0.072;
            multiplyMatrix([(_local5 + (_local3 * (1 - _local5))) + (_local2 * (-_local5)), (_local4 + (_local3 * (-_local4))) + (_local2 * (-_local4)), (_local6 + (_local3 * (-_local6))) + (_local2 * (1 - _local6)), 0, 0, (_local5 + (_local3 * (-_local5))) + (_local2 * 0.143), (_local4 + (_local3 * (1 - _local4))) + (_local2 * 0.14), (_local6 + (_local3 * (-_local6))) + (_local2 * -0.283), 0, 0, (_local5 + (_local3 * (-_local5))) + (_local2 * (-(1 - _local5))), (_local4 + (_local3 * (-_local4))) + (_local2 * _local4), (_local6 + (_local3 * (1 - _local6))) + (_local2 * _local6), 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);
        }
        function concat(p_matrix) {
            p_matrix = fixMatrix(p_matrix);
            if (p_matrix.length != LENGTH) {
                return(undefined);
            }
            multiplyMatrix(p_matrix);
        }
        function clone() {
            return(new com.gskinner.geom.ColorMatrix(this));
        }
        function toString() {
            return(("ColorMatrix [ " + this.join(" , ")) + " ]");
        }
        function toArray() {
            return(this.slice(0, 20));
        }
        function copyMatrix(p_matrix) {
            var _local3 = LENGTH;
            var _local2 = 0;
            while (_local2 < _local3) {
                this[_local2] = p_matrix[_local2];
                _local2++;
            }
        }
        function multiplyMatrix(p_matrix) {
            var _local6 = [];
            var _local5 = 0;
            while (_local5 < 5) {
                var _local3 = 0;
                while (_local3 < 5) {
                    _local6[_local3] = this[_local3 + (_local5 * 5)];
                    _local3++;
                }
                _local3 = 0;
                while (_local3 < 5) {
                    var _local4 = 0;
                    var _local2 = 0;
                    while (_local2 < 5) {
                        _local4 = _local4 + (p_matrix[_local3 + (_local2 * 5)] * _local6[_local2]);
                        _local2++;
                    }
                    this[_local3 + (_local5 * 5)] = _local4;
                    _local3++;
                }
                _local5++;
            }
        }
        function cleanValue(p_val, p_limit) {
            return(Math.min(p_limit, Math.max(-p_limit, p_val)));
        }
        function fixMatrix(p_matrix) {
            if (p_matrix instanceof com.gskinner.geom.ColorMatrix) {
                p_matrix = p_matrix.slice(0);
            }
            if (p_matrix.length < LENGTH) {
                p_matrix = p_matrix.slice(0, p_matrix.length).concat(IDENTITY_MATRIX.slice(p_matrix.length, LENGTH));
            } else if (p_matrix.length > LENGTH) {
                p_matrix = p_matrix.slice(0, LENGTH);
            }
            return(p_matrix);
        }
        static var DELTA_INDEX = [0, 0.01, 0.02, 0.04, 0.05, 0.06, 0.07, 0.08, 0.1, 0.11, 0.12, 0.14, 0.15, 0.16, 0.17, 0.18, 0.2, 0.21, 0.22, 0.24, 0.25, 0.27, 0.28, 0.3, 0.32, 0.34, 0.36, 0.38, 0.4, 0.42, 0.44, 0.46, 0.48, 0.5, 0.53, 0.56, 0.59, 0.62, 0.65, 0.68, 0.71, 0.74, 0.77, 0.8, 0.83, 0.86, 0.89, 0.92, 0.95, 0.98, 1, 1.06, 1.12, 1.18, 1.24, 1.3, 1.36, 1.42, 1.48, 1.54, 1.6, 1.66, 1.72, 1.78, 1.84, 1.9, 1.96, 2, 2.12, 2.25, 2.37, 2.5, 2.62, 2.75, 2.87, 3, 3.2, 3.4, 3.6, 3.8, 4, 4.3, 4.7, 4.9, 5, 5.5, 6, 6.5, 6.8, 7, 7.3, 7.5, 7.8, 8, 8.4, 8.7, 9, 9.4, 9.6, 9.8, 10];
        static var IDENTITY_MATRIX = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];
        static var LENGTH = IDENTITY_MATRIX.length;
    }
