package Tk::Gpack ; 

use Exporter                ; 
use Tk::Widget              ; 
our @ISA = qw(Exporter Tk::Widget) ;
our @EXPORT = qw(gpack xpack spack tpack ggrid xgrid sgrid tgrid gunderline _packinate _gridinate) ;
our $VERSION = '0.05' 	    ;
 
package Tk ;  # Gleefully pollute the root namespace. 
Exporter::import qw(Tk::Gpack gpack tpack spack xpack tgrid ggrid xgrid sgrid _packinate _gridinate); 

package Tk::Gpack ; 

sub gpack { # Group Pack   
###########
	my @tp = @_    ; # To pack 
	my $count = 0  ; 
	foreach (@tp) {
		if ($count % 2) { # If odd 
			$tp[$count - 1]->pack(_packinate($tp[$count])) ;
		}
		$count++ ;
	}
}

sub tpack { # Target Pack, group pack in a target   
###########
	my $self = shift ; 
	my @tp = @_      ; # To pack 
	my $count = 0    ; 
	foreach (@tp) {
		if ($count % 2) { # If odd 
			$tp[$count - 1]->pack(_packinate($tp[$count]), -in => $self) ;
		}
		$count++ ;
	}
}

sub xpack { # Expand Pack
###########
	my $self = shift   ; 
	my $string = shift ; 
	my @options = @_   ; 
	push @options,  _packinate($string) ; 
	$self->pack(@options) ; 
} 

sub spack { # self pack, assume the object has a data configspec called -geometry
#############
	my $self = shift ;
	my @options = @_ ;  
	my $string = $self->cget('-geometry') ;
	$self->xpack($string, @options)       ; 
}

sub ggrid { # Group Grid
###########
	my @tg = @_    ; # To grid 
	my $count = 0  ; 
	foreach (@tg) {
		if ($count % 2) { # If odd 
			$tg[$count - 1]->grid(_gridinate($tg[$count])) ;
		}
		$count++ ;
	}
}

sub tgrid { # Group Grid
###########
	my $self = shift ; 
	my @tg = @_      ; # To grid 
	my $count = 0    ; 
	foreach (@tg) {
		if ($count % 2) { # If odd 
			$tg[$count - 1]->grid(_gridinate($tg[$count]), -in => $self) ;
		}
		$count++ ;
	}
}

sub xgrid { # Expand Grid
###########
	my $self = shift   ; 
	my $string = shift ; 
	my @options = @_   ; 
	push @options,  _gridinate($string) ; 
	$self->grid(@options) ; 
}

sub sgrid { # self pack, assume the object has a data configspec called -geometry
#############
	my $self = shift ;
	my @options = @_ ;  
	my $string = $self->cget('-geometry') ;
	$self->xgrid($string, @options)       ; 
}

sub gunderline { # Group underline
#################
	my @tu = @_ ; # too underline 
	my $count = 0  ; 
	foreach (@tu) {
		if ($count % 2) { # If odd 
			$tu[$count - 1]->configure("-underline" => $tu[$count]) ;
		}
		$count++ ;
	}
}

sub _packinate {
###############
	# -padx and -pady are now ony effective to a single character. 
	# TODO: These should be forward reading
	# 
	my $string = shift ;
	#  warn $string ;
	my $foo = 0     ;
	#################### Switches 
	my $x1 = "-expand" ; 
	my $s1 = "-side"   ; 
	my $a = "-anchor"  ; 
	my $f = "-fill"    ;
	my $X = "-padx"    ;
	my $Y = "-pady"	 ; 
	#################### Values
	my $c = "center"   ; 
	my $l = "left" 	 ; 
	my $r = "right"    ; 
	my $t = "top"      ;
	my $n = "n"   ; 
	my $s2 = "s"  ; 
	my $e = "e"	  ; 
	my $w = "w"	  ; 
	my $y = "y"   ; 
	my $x2 = "x"  ; 
	my $b1 = "both"    ;
	my $b2 = "bottom"  ;   
	my @chars = split(//,$string) ;
	#################### 
	my $last ;
	my $count = 0     ;  
	foreach (@chars) { # single characters.
		if (s/a/$a/) { } 
		elsif (s/f/$f/) { } 
		elsif (s/X/$X/) { } 
		elsif (s/Y/$Y/) { } 
		elsif (s/c/$c/) { } 
		elsif (s/l/$l/) { } 
		elsif (s/r/$r/) { } 
		elsif (s/t/$t/) { } 
		elsif (s/n/$n/) { } 
		elsif (s/e/$e/) { } 
		elsif (s/w/$w/) { } 
		elsif (s/y/$y/) { $foo = 1 ; } 
		elsif ($_ =~ /x/) {if ($last =~ /$f/) {$_ = $x2 ; } else {$_ = $x1 ; } }
		elsif ($_ =~ /s/) {if ($last =~ /$a/) { $_ = $s2 ; } else {$_ = $s1 ; } }  
		elsif ($_ =~ /b/) {if ($last =~ /$s1/) { $_ = $b2 ; } else {$_ = $b1 ; } }
		##########
		$chars[$count] = $_ ; 
		$last = $_ ;
		$count++ ;    
	} 
	# 
	$count = 0  ;
	my @vals ; 
	foreach (@chars) {
		if ($count % 2) { # If odd 
			push @vals, ($chars[$count - 1] => $chars[$count]) ;
		}
		$count++ ; 
	}
	warn @vals if $foo ;  
	return @vals ; 
}

sub _gridinate {
###############
	# Untested
	my $string = shift   ;
	my $row = $string    ; 
	my $col = $string    ;
	my $sticky = $string ;  
	my @vals ; 

	$row =~ s/.*r([0-9]+).*/$1/ ;  # Keep the numbers that previously followed "r"
	$col =~ s/.*c([0-9]+).*/$1/ ;  #
	$sticky =~ s/([cr][0-9]+)//g  ;# delete all other possible pairs 
	if ($sticky =~ /s/) { 
		$sticky =~ s/s(...)/$1/ ; # allow for sw se etc. 
		$sticky =~ s/^s//       ;  
		push @vals, ("-sticky" => $sticky) ;  
	} 
	unshift @vals, ("-row" => $row)    ;
	unshift @vals, ("-column" => $col) ;
	# warn "$row $col $sticky"           ;   
	return @vals ; 	 
}

1; 

__END__

=head1 NAME

Tk::Gpack - Group Packer, Suite of abbreviation tools for pack and grid

=head1 SYNOPSIS

gpack qw($frame1 stawx1fx $frame2 stawx1fb $frame3 stawx1fb) ; # group pack

# same as: 
# $frame1->pack(side => top, -anchor => w, -expand => 1, -fill => x) ;   
# $frame2->pack(-side => top, -anchor => w, -expand => 1, -fill => both) ;   
# $frame3->pack(-side => top, -anchor => w, -expand => 1, -fill => both) ;    

$button1->xpack('slan', -in => $frame1)  ; # expand pack

# same as: 
# $button1->pack(-side => left, -anchor => n, -in => $frame1) ; 

tpack qw($frame1 $button1 slan $button2 slan) ; # target pack 

# same as: 
# $button1->pack(-side => left, -anchor => north, -in => $frame1) ; 
# $button2->pack(-side => left, -anchor => north, -in => $frame1) ; 
 
$derivedbutton1->configure(-geometry => 'slan') ; 
$derivedbutton1->spack(-in => $frame3)          ; # self pack 

# Note: This only works with Derived objects that define a -geometry ConfigSpec. 
# Effectively this allows any derived widgets you create to embed their own 
# gpack or ggrid formated string.  

ggrid qw($button1 r0c0 $button2 r10c10) ; # group grid 

# Grids buttons in opposite corners. 

tgrid qw($frame1 $button1 r0c0 $button2 r10c10) ; # target grid 

# stick $button1 and button2 in $frame1 and in opposite corners

$button1->xgrid('r5c15', -in => $someframe) ; # expand grid

# grid it, and stick it in $someframe

$derivedbutton1->configure(-geometry => 'r0c2') ; 
$derivedbutton1->sgrid() ; # self grid 

#Note: as above sgrid is depenent on the the widget being Derived. 
#

=head1 DESCRIPTION

Gpack uses a series of single letter abbreviations to expand packing or gridding options. The functions these strings are as above: gpack xpack spack tpack, ggrid xgrid sgrid and tgrid.  
by using this module all of these functions will be exported into the Tk namespace.

Note that not all of the options available to pack and to grid are available at this time, but 
the most usefull ones are. Duplicate character values have left reading context awareness. (to a small degree), so gpack should know that x1fx or fxx1 is (-expand => 1, -fill => x) in all cases.

Only xpack,spack, xgrid,sgrid can be called in a object form. So the following is correct: 

$foo->xpack('slan')       ; 
gpack($foo, 'slan') ; 

But this is wrong: 
$foo->gpack() ;  

Note also that because of the 1 character per optionvalue rule padding widgets is limited to a single 
diget argument. Sorry, but thems the rules. 

Ggrid is even more simple: c for column, r for row, s for sticky. Ggrid does except multicharacter numbers as options unlike pack. So your free to have as many rows and columns as you like. 

spack and sgrid (Self Pack and Self Grid) are intended to work with Derived Widgets. If you don't 
know what a Derived widget is then just forget I even mentioned these functions. 

	# Abbreviations for ?pack() ; 
	################### Options
	x = "-expand" ; 
	s = "-side"   ; 
	a = "-anchor"  ; 
	f = "-fill"    ;
	X = "-padx"    ;
	Y = "-pady"	 ; 
	#################### Values
	c = "center"   ; 
	l = "left" 	   ; 
	r = "right"    ; 
	t = "top"      ;
	n = "n"        ;  
	s = "s"        ; 
	e = "e"	   ; 
	w = "w"	   ; 
	y = "y"        ; 
	x = "x"        ; 
	b = "both"     ;
	b = "bottom"   ;   
      ####################

	# Abbreviations for ?grid()
	####################
	r = "-row" 
	c = "-column"
	s = "-sticky"
	
=head1 BUGS 

Probably 

=head1 AUTHOR

Matthew Sibley matt@crosswire.com

=cut
