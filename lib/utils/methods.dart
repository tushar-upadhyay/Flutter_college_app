double map({double inputlo,double inputhi,double outputlo,double outputhi,double val}) =>outputlo +inputlo +((outputhi - outputlo) / (inputhi - inputlo)) * val;

