alpha=30;
h=60    ;
W1=12;
thickness=1.8;
L=h/cos(alpha);
echo("L");echo(L);
L2b=2*thickness;
W=19.5;
slotoffset=2;
slotspace=6.7;
cutline=1;

    // Orthogonal leg: 
//    pleg=L*sin(alpha)*sin(alpha);
//    L2a=L2b + L*sin(alpha)*cos(alpha);
//    Eleg=thickness;

    // generic leg
    pleg=10;
    hleg=pleg*cos(alpha) + thickness*sin(alpha);
    Cleg=L*sin(alpha) - (pleg*sin(alpha)-thickness*cos(alpha));
    alphaleg=atan(hleg/Cleg);
    //echo(alphaleg);
    Eleg=thickness*(1+sin(alpha-alphaleg))/cos(alpha-alphaleg);
    echo("Eleg");
    echo(Eleg);
    d=sqrt(Eleg*Eleg+thickness*thickness);
    L2a=L2b + hleg/sin(alphaleg) - d * sin(acos(thickness/d));
    echo("Leg length");
    echo(L2a-L2b);


E1=thickness*(1 + sin(alpha))/cos(alpha);
echo("E1");
echo(E1);

L3=15; // keyboard
L4=20; // screen

L3a=W;
L3b=L3a+L3;
Wkeyboard=60;
echo("Keyboard");
echo([Wkeyboard,L3b]);

L4a=W1;
L4b=L4a+L4;
Wscreen=30;
echo("Screen");
echo([Wscreen,L4b]);
slotscreen=5;
hscreen = (slotoffset + slotspace*slotscreen)*cos(alpha)
    + thickness*sin(alpha);

slotkeyboard=2;
hkeyboard = (slotoffset + slotspace*slotkeyboard)*cos(alpha)
    + thickness*sin(alpha);

echo("Length");
echo(L+W1+W1+(Wscreen-W1)/2+(Wkeyboard-W1)/2+2*cutline);
echo("Width");
echo(L4b+cutline);

// projection(cut=false) translate([0,0,50]) 
{
//Mounting
rotate([0,-(90-alpha),0]) 
//Cutting
//translate([-L4a,(W+W1)/2+2,0])
color("#00FF00",0.5)
difference() {
    linear_extrude(height=thickness) {
        polygon(points=[[0,-W/2],[L,-W/2],[L,W/2],[0,W/2]]);
    }
    union() {
        echo("p");
        for (i=[2:9]) {
            translate([0,0,-1]) linear_extrude(height=thickness+2) {
                p=slotoffset+slotspace*i;
                echo([p,p+E1]);
                polygon(points=[[p,-1.05*W1/2],[p+E1,-1.05*W1/2],[p+E1,1.05*W1/2],[p,1.05*W1/2]]);
            }
        }
        translate([0,0,-1]) linear_extrude(height=thickness+2) {
            polygon(points=[[pleg,-1.05*W1/2],[pleg+Eleg,-1.05*W1/2],[pleg+Eleg,1.05*W1/2],[pleg,1.05*W1/2]]);
        }
    }
}

// Cutting
//translate([Wscreen/2-W1/2,(W+W)/2+cutline,0])
color("#FF00FF")
// Mounting
translate([(L2a-L2b)*cos(alphaleg)+(pleg+Eleg)*sin(alpha)-thickness*sin(alphaleg),0,0])
rotate([0,alphaleg,0])
translate([-L2a,0,0])
linear_extrude(height=thickness) {
    polygon(points=[[0,-W1/2],[L2b,-W1/2],[L2b,-W/2],
           [L2a,-W/2],[L2a,W/2],[L2b,W/2],[L2b,W1/2],[0,W1/2]]);
}

// Mounting
translate([hscreen*tan(alpha)+0.8*L4a,0,hscreen])
rotate([0,0,180])
// Cutting
//translate([-cutline-W1/2,cutline-W/2,0])
//rotate([0,0,90])
color("#FF0000",0.5) 
linear_extrude(height=thickness) {
    polygon(points=[[0,-W1/2],[L4a,-W1/2],[L4a,-Wscreen/2],
           [L4b,-Wscreen/2],[L4b,Wscreen/2],
            [L4a,Wscreen/2],[L4a,W1/2],[0,W1/2]]);
}


// Mounting
translate([hkeyboard*tan(alpha)+0.5*L3a,0,hkeyboard])
rotate([0,0,180])
// Cutting
//translate([cutline+L+W1/2,cutline-W/2,0])
//rotate([0,0,90])
//translate([2,0,0])
color("#00FFFF",0.5) 
linear_extrude(height=thickness) {
    polygon(points=[[0,-W1/2],[L3a,-W1/2],[L3a,-Wkeyboard/2],
           [L3b,-Wkeyboard/2],[L3b,Wkeyboard/2],
            [L3a,Wkeyboard/2],[L3a,W1/2],[0,W1/2]]);
}
}