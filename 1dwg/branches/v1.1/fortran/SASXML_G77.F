*
*
*	F77 SUBROUTINE XMLIP2 TO READ CANSAS SASXML V1.0 and v1.1 1D TREATED DATA FILES
*	AND EXAMPLE IMPLEMENTATION PROGRAM EXAMPLE_READ_SASXML
*
*	READS UP TO 4 NUMERICAL FIELDS (Q, I, (Idev, (Qdev)))
*	ALSO READS THE FOLLOWING META DATA FIELDS:
*	  <SASentry>
*	    <run>
*	    <title>
*	  </SASentry>
*	  <SASprocess>
*	    <date>
*	    <wavelength_min>
*	    <wavelength_max>
*	    <term name="radius_min">
*	    <term name="radius_max">
*	    <term name="sector_width">
*	    <term name="scale_factor">
*	  </SASprocess>
*	  <SASprocessnote>
*	    <name="data_mode">
*	  <SASprocessnote>
*
*	ALSO PARSES THE UNITS OF Q FOR A X-AXIS TITLE
*	ALSO PARSES THE UNITS OF I FOR A Y-AXIS TITLE
*
*	(C)2008, S M KING, ISIS, RAL, UK
*
*	THIS CODE MAY BE REDISTRIBUTED AND REUSED WITHOUT RESTRICTION PROVIDED
*	AN ACKNOWLEDGEMENT TO THE ORIGINAL AUTHOR IS RETAINED
*
*	ALSO SEE:
*	http://www.cansas.org/formats/canSAS1d/1.1/doc/


C===============================================================================


	program example_read_sasxml

	real*4		x(16384),y(16384),e(16384),f(16384)
	real*4		x_mn,x_mx,y_mn,y_mx
	real*4		meta(6)
	real*4		lambda_min,lambda_max
	real*4		phi_min,phi_max
	real*4		r_min,r_max
	real*4		scale
	integer*4	id,len_recl,n
	integer*4	ipflag,ipflag2
	character*6	run
	character*9	mode
	character*20	date
	character*60	title
        character*79    xtit,ytit
	character*80	filnam


100	format(' Run number  : ',a6)
101	format(' Date of run : ',a20)
102	format(' Title string: ',a60)
103	format(' Type of data: ',a9)
104	format(' Q is:')
105	format(' I is:')
106	format(a79)
107	format(' Xmin: ',e12.5,'     Xmax: ',e12.5)
108	format(' Ymin: ',e12.5,'     Ymax: ',e12.5)
109	format(' Number of data points: ',i6)
110	format(' XML file to read?> ',$)
111	format(a80,$)

	write(6,*)'EXAMPLE_READ_SASXML'
1	write(6,110)
	read(5,111,err=1)filnam
	write(6,*)' '

*	INPUT UNIT ID
	id=4

*	ERROR FLAGS
	ipflag=1
	ipflag2=1

*	MAX INPUT RECORD (IE, LINE) LENGTH
*	CHARACTER INPUT FORMAT STATEMENT IN SUBROUTINE XMLIP2 SHOULD BE
*	SET TO MATCH
	len_recl=200

*	G77 NOT VERY HAPPY ABOUT READONLY CONTROL STATEMENT
*1000     OPEN(UNIT=id,FILE=filnam,RECL=len_recl,STATUS='old',READONLY,ERR=9999)
1000     OPEN(UNIT=id,FILE=filnam,RECL=len_recl,STATUS='old',ERR=9999)

           if (ipflag2.eq.1) then
             write(6,*)'Reading canSAS SASXML-compliant file'
	     write(6,*)' '
           else
	     write(6,*)' '
             write(6,*)'Extracting next entry'
	     write(6,*)' '
           end if

*	   NUMBER OF DATA POINTS
	   n=0
*	   MIN X VALUE
	   x_mn=0.
*	   MAX X VALUE
	   x_mx=0.
*	   MIN Y VALUE
	   y_mn=0.
*	   MAX X VALUE
	   y_mx=0.

C    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
           CALL XMLIP2
     &     (id,n,len_recl,
     &     x,y,e,f,
     &     title,date,run,
     &     xtit,ytit,
     &     x_mn,x_mx,y_mn,y_mx,
     &     meta,mode,ipflag,ipflag2)
C    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

*	   LIMIT DATA TO ARRAY BOUNDS - CHANGE BOUNDS AS REQUIRED
	   if (n.gt.16384) n=16384

*	   ERROR CODES
	   if (ipflag.ne.0) then
	      if (ipflag.eq.-1) then
	          write(6,*)'ERROR[-1]: Is XML data block formatted correctly?'
	      else if (ipflag.eq.-2) then
	          write(6,*)'ERROR[-2]: Cannot read more of this file'
	      else if (ipflag.eq.-3) then
	          write(6,*)'ERROR[-3]: End of file encountered'
	      else if ((ipflag.eq.-4).or.(n.eq.0)) then
	          write(6,*)'ERROR[-4]: No data read from file'
	      else if ((ipflag.ne.1).and.(ipflag2.gt.1)) then
	          write(6,*)'ERROR: IPFLAG has an unexpected value'
	          write(6,*)'IPFLAG:  ',ipflag
	          write(6,*)'IPFLAG2: ',ipflag2
	      end if
	   end if

*	   TYPE DATA VALUES TO SCREEN
	   do i=1,n
	      write(6,*)x(i),y(i),e(i),f(i)
	   end do

*	   INTERPRET META DATA
	   if (ipflag.ge.0) then
*	      WAVELENGTH RANGE
	      if (meta(1).le.0.22) then
	         lambda_min=meta(1)*10.
	         lambda_max=meta(2)*10.
	      else
	         lambda_min=meta(1)
	         lambda_max=meta(2)
	      end if
*	      RADIAL INTEGRATION LIMITS
	      r_min=meta(3)
	      r_max=meta(4)
*	      AZIMUTHAL ANGLE RANGE
	      phi_min=meta(5)*-1
	      phi_max=meta(5)
*	      INTENSITY SCALE FACTOR
	      scale=meta(6)

*	      TYPE META DATA TO SCREEN
	      write(6,*)' '
	      write(6,*)'XML data has been input'
	      write(6,*)' '
	      write(6,100)run
	      write(6,101)date
	      write(6,102)title
	      write(6,103)mode
	      write(6,104)
	      write(6,106)xtit
	      write(6,105)
	      write(6,106)ytit
	      write(6,107)x_mn,x_mx
	      write(6,108)y_mn,y_mx
	      write(6,109)n
	   end if

	close(unit=id)

*	GO LOOK FOR ANOTHER SASENTRY IN THE FILE
	if (ipflag.gt.0) goto 1000

9999	end


C===============================================================================

        SUBROUTINE XMLIP2
     &  (IUNIT,N,IRECL,
     &   A,B,C,D,TITLE,DATE,RUN,XTIT,YTIT,XMIN,XMAX,YMIN,YMAX,METAVAL,DATA_MODE,
     &   FLAG,FLAG2)
        integer         iunit,n,irecl,flag,flag2
	real*4		metaval(6),xmin,xmax,ymin,ymax
        real*4          a(*),b(*),c(*),d(16384)
        character*79    xtit,ytit
	character*6	run
	character*20	date
	character*60	title

*	CHANGED FIELD1 FROM CHAR*8 TO HANDLE ILL DATA
	character*9	field1
	character*12	field2
	character*9	field3,field4,data_mode

	integer		nchars,ipos,jpos,kpos(7),lpos(7),mpos(7),npos(7)
	integer		len_line

	logical		got_title,got_run,got_date,got_mode,on_entry
	logical		got_lmin,got_lmax,got_rmin,got_rmax,next_data
	logical		got_sector,got_scale,read_entry,next_entry
	logical		found_data,read_data,got_data,found_endroot

        character*200   line,line2
1000	format(a200)

	on_entry=.true.
	got_title=.false.
	got_run=.false.
	got_date=.false.
	got_lmin=.false.
	got_lmin=.false.
	got_rmin=.false.
	got_rmax=.false.
	got_sector=.false.
	got_scale=.false.
	got_mode=.false.
	got_data=.false.
	read_data=.false.
	found_data=.false.
	next_data=.false.
	read_entry=.false.
	next_entry=.false.
	found_endroot=.false.

        n=1

	xtit='                                          
     &                                      '

	ytit='                                          
     &                                      '

1       line='                                                  
     &                                                  
     &                                                  
     &                                                  '

*	USE FLAG2 TO COUNT LINE NUMBER OF FILE WITH </SASentry>
*	SO CAN SKIP BETWEEN ENTRIES IN EXTENDED FILES
	if ((on_entry).and.(flag2.gt.1)) then
	   do i=1,flag2
	      read(unit=iunit,fmt=1000,err=8887,end=8886)line
*	      WRITE(6,'(i6,a80)')flag2,line(1:80)
	   end do
	   on_entry=.false.
*	   WRITE(6,*)'Skipped previous entry...'
	end if

2	read(unit=iunit,fmt=1000,err=8887,end=8886)line
*	WRITE(6,'(i6,a80)')flag2,line(1:80)
	ipos=0
	jpos=0

*	GET THE TITLE STRING
	if (.not.got_title) then
	   ipos=index(line(1:200),'<Title>')
	   jpos=index(line(1:200),'</Title>')
	   title(1:60)=
     &     '                                                             '
	   if ((ipos.gt.0).and.(jpos.gt.0)) then
	      nchars=(jpos-1)-(ipos+7)+1
	      if (nchars.le.26) then
	         title(1:nchars)=line(ipos+7:jpos-1)
	      else
	         title(1:26)=line(ipos+7:ipos+7+26)
	      end if
	      got_title=.true.
*	      WRITE(6,*)TITLE(1:60)
	   end if
	end if

*	GET THE RUN NUMBER
	if (.not.got_run) then
	   ipos=index(line(1:200),'<Run>')
	   jpos=index(line(1:200),'</Run>')
	   run(1:6)='      '
	   if ((ipos.gt.0).and.(jpos.gt.0)) then
	      nchars=(jpos-2)-(ipos+5)+1
	      if (nchars.le.6) then
	         run(1:nchars)=line(ipos+5:jpos-2)
	      else
	         run(1:6)=line(ipos+5:ipos+5+6)
	      end if
*	      WRITE(6,*)RUN(1:6)
	      got_run=.true.
	   end if
	end if

*	GET THE DATE
	if (.not.got_date) then
	   ipos=index(line(1:200),'<date>')
	   jpos=index(line(1:200),'</date>')
	   date(1:20)='                    '
	   if ((ipos.gt.0).and.(jpos.gt.0)) then
	      nchars=(jpos-2)-(ipos+7)+1
	      if (nchars.le.20) then
	         date(1:nchars)=line(ipos+7:jpos-2)
	      else
	         date(1:20)=line(ipos+7:ipos+7+20)
	      end if
*	      WRITE(6,*)DATE(1:20)
	      got_date=.true.
	   end if
	end if

*	GET THE MIN WAVELENGTH
*	FIRST ASSUME IT'S IN NM
	if (.not.got_lmin) then
	   ipos=index(line(1:200),'<wavelength_min unit="nm">')
	   jpos=index(line(1:200),'</wavelength_min>')
	   metaval(1)=0.0
	   if ((ipos.gt.0).and.(jpos.gt.0)) then
              read(line(ipos+26:jpos-2),'(f5.2)')metaval(1)
*	      WRITE(6,*)METAVAL(1)
	      got_lmin=.true.
	   end if
	end if

*	OTHERWISE SEE IF IT'S IN ANGSTROMS
	if (.not.got_lmin) then
	   ipos=index(line(1:200),'<wavelength_min unit="A">')
	   jpos=index(line(1:200),'</wavelength_min>')
	   metaval(1)=0.0
	   if ((ipos.gt.0).and.(jpos.gt.0)) then
              read(line(ipos+25:jpos-2),'(f5.2)')metaval(1)
*	      WRITE(6,*)METAVAL(1)
	      got_lmin=.true.
	   end if
	end if

*	GET THE MAX WAVELENGTH
*	FIRST ASSUME IT'S IN NM
	if (.not.got_lmax) then
	   ipos=index(line(1:200),'<wavelength_max unit="nm">')
	   jpos=index(line(1:200),'</wavelength_max>')
	   metaval(2)=0.0
	   if ((ipos.gt.0).and.(jpos.gt.0)) then
              read(line(ipos+26:jpos-2),'(f5.2)')metaval(2)
*	      WRITE(6,*)METAVAL(2)
	      got_lmax=.true.
	   end if
	end if

*	OTHERWISE SEE IF IT'S IN ANGSTROMS
	if (.not.got_lmax) then
	   ipos=index(line(1:200),'<wavelength_max unit="A">')
	   jpos=index(line(1:200),'</wavelength_max>')
	   metaval(2)=0.0
	   if ((ipos.gt.0).and.(jpos.gt.0)) then
              read(line(ipos+25:jpos-2),'(f5.2)')metaval(2)
*	      WRITE(6,*)METAVAL(2)
	      got_lmax=.true.
	   end if
	end if

*	GET THE INTENSITY SCALE FACTOR
	if (.not.got_scale) then
	   ipos=index(line(1:200),'<term name="scale_factor" unit="a.u.">')
	   jpos=index(line(1:200),'</term>')
	   metaval(6)=0.0
	   if ((ipos.gt.0).and.(jpos.gt.0)) then
              read(line(ipos+38:jpos-2),'(f7.4)')metaval(6)
*	      WRITE(6,*)METAVAL(6)
	      got_scale=.true.
	   end if
	end if

*	GET THE MIN RADIUS OF RADIAL AVERAGING
	if (.not.got_rmin) then
	   ipos=index(line(1:200),'<term name="radius_min" unit="mm">')
	   jpos=index(line(1:200),'</term>')
	   metaval(3)=0.0
	   if ((ipos.gt.0).and.(jpos.gt.0)) then
              read(line(ipos+34:jpos-2),'(f6.1)')metaval(3)
*	      WRITE(6,*)METAVAL(3)
	      got_rmin=.true.
	   end if
	end if

*	GET THE MAX RADIUS OF RADIAL AVERAGING
	if (.not.got_rmax) then
	   ipos=index(line(1:200),'<term name="radius_max" unit="mm">')
	   jpos=index(line(1:200),'</term>')
	   metaval(4)=0.0
	   if ((ipos.gt.0).and.(jpos.gt.0)) then
              read(line(ipos+34:jpos-2),'(f6.1)')metaval(4)
*	      WRITE(6,*)METAVAL(4)
	      got_rmax=.true.
	   end if
	end if

*	GET THE ANGULAR RANGE OF RADIAL AVERAGING
	if (.not.got_sector) then
	   ipos=index(line(1:200),'<term name="sector_width" unit="degree">')
	   jpos=index(line(1:200),'</term>')
	   metaval(5)=0.0
	   if ((ipos.gt.0).and.(jpos.gt.0)) then
              read(line(ipos+40:jpos-2),'(f6.1)')metaval(5)
*	      WRITE(6,*)METAVAL(5)
	      got_sector=.true.
	   end if
	end if

*	GET THE DATA MODE
	if (.not.got_mode) then
	   ipos=index(line(1:200),'<SASprocessnote name="data_mode">')
	   jpos=index(line(1:200),'</SASprocessnote>')
	   data_mode(1:9)='         '
	   if ((ipos.gt.0).and.(jpos.gt.0)) then
	      nchars=(jpos-1)-(ipos+33)+1
	      if (nchars.le.9) then
	         data_mode(1:nchars)=line(ipos+33:jpos-1)
	      else
	         data_mode(1:9)=line(ipos+34:ipos+34+9)
	      end if
*	      WRITE(6,*)DATA_MODE(1:9)
	      got_mode=.true.
	   end if
	end if

*	GET DATA IF NOT ALREADY DONE SO
	if ((.not.found_data).and.(.not.read_data)) then
*	   FIRST TEST FOR START OF DATA BLOCK
	   ipos=index(line(1:200),'<SASdata')
	   if (ipos.gt.0) found_data=.true.
	   if (ipos.gt.0) flag2=flag2+1
	   if (found_data) then
*	      IF FOUND DATA BLOCK, READ NEXT LINE WHICH SHOULD BE DATA...
*	      WRITE(6,*)'Found data block...'

3	      read(unit=iunit,fmt=1000,err=4,end=8886)line
*	      WRITE(6,'(i6,a80)')flag2,line(1:80)

*	      BUT TEST FOR END OF DATA BLOCK
	      ipos=0
	      ipos=index(line(1:200),'</SASdata>')
	      if (ipos.gt.0) read_data=.true.
*	      STOP READING DATA IF REACHED END OF DATA BLOCK
	      if (read_data) goto 4
*	      OTHERWISE GRAB THE DATA VALUES
	      a(n)=0.
	      b(n)=0.
	      c(n)=0.
	      d(n)=0.
	      ipos=0
	      jpos=0
	      ipos=index(line(1:200),'<Idata>')
	      jpos=index(line(1:200),'</Idata>')
*	      CHECK IT'S A VALID DATA RECORD
	      if ((ipos.gt.0).and.(jpos.gt.0)) then
	         len_line=jpos-ipos+1
                 line2='                                                  
     &                                                  
     &                                                  
     &                                                  '
	         line2(1:len_line)=line(ipos:jpos)
*	         FIRST THE X DATA...
*	         NB: SASXML STANDARD ALLOWS UP TO 6 COLUMNS OF DATA
*	         SO KPOS, LPOS, MPOS & NPOS HELP DEFINE THE SUBSTRINGS  OF THE
*	         IDATA STRING THAT DEFINE THE DATA TYPE (Q, I, ETC), IT'S
*	         UNITS, AND ITS NUMERIC VALUE, WHILST ARRAY INDICIES 2-7
*	         REPRESENT DATA COLUMNS 1-6
	         do i=1,7
	           kpos(i)=0
	           lpos(i)=0
	           mpos(i)=0
	           npos(i)=0
	         end do
	         do i=2,7
	           kpos(i)=index(line2(1+npos(i-1):len_line),'><')+npos(i-1)
	           lpos(i)=index(line2(1+npos(i-1):len_line),'unit')+npos(i-1)
	           mpos(i)=index(line2(1+npos(i-1):len_line),'">')+npos(i-1)
	           npos(i)=index(line2(1+npos(i-1):len_line),'</')+npos(i-1)
	         end do

*	         CONSTRUCT AXIS TITLES
	         xtit(1:79)=line2(kpos(2)+2:lpos(2)-2)//
     &           '  ('//line2(lpos(2)+6:mpos(2)-1)//')'
	         ytit(1:79)=line2(kpos(3)+2:lpos(3)-2)//
     &           '  ('//line2(lpos(3)+6:mpos(3)-1)//')'

*	         READ AND CONVERT THE DATA VALUE FIELDS
*	         kpos='><'
*	         lpos='unit'
*	         mpos='">'
*	         npos='</'

	         if ((line2(mpos(2)+2:mpos(2)+2).eq.' ').and.
     &              (line2(npos(2)-1:npos(2)-1).eq.' ')) then
	               field1=line2(mpos(2)+2:npos(2)-2)
	               read(field1,*)a(n)
	         else if ((line2(mpos(2)+2:mpos(2)+2).eq.' ').and.
     &           (line2(npos(2)-1:npos(2)-1).ne.' ')) then
	               field1=line2(mpos(2)+2:npos(2)-1)
	               read(field1,*)a(n)
	         else if ((line2(mpos(2)+2:mpos(2)+2).ne.' ').and.
     &           (line2(npos(2)-1:npos(2)-1).eq.' ')) then
	               field1=line2(mpos(2)+2:npos(2)-2)
	               read(field1,*)a(n)
	         else
	            field1=line2(mpos(2)+2:npos(2)-1)
	            read(field1,*)a(n)
	         end if

	         if ((line2(mpos(3)+2:mpos(3)+2).eq.' ').and.
     &              (line2(npos(3)-1:npos(3)-1).eq.' ')) then
	               field2=line2(mpos(3)+2:npos(3)-2)
	               read(field2,*)b(n)
	         else if ((line2(mpos(3)+2:mpos(3)+2).eq.' ').and.
     &           (line2(npos(3)-1:npos(3)-1).ne.' ')) then
	               field2=line2(mpos(3)+2:npos(3)-1)
	               read(field2,*)b(n)
	         else if ((line2(mpos(3)+2:mpos(3)+2).ne.' ').and.
     &           (line2(npos(3)-1:npos(3)-1).eq.' ')) then
	               field2=line2(mpos(3)+2:npos(3)-2)
	               read(field2,*)b(n)
	         else
	            field2=line2(mpos(3)+2:npos(3)-1)
	               read(field2,*)b(n)
	         end if

*	         CHECK FOR 3RD COLUMN
	         if (lpos(4).gt.kpos(4)) then
	          if ((line2(mpos(4)+2:mpos(4)+2).eq.' ').and.
     &              (line2(npos(4)-1:npos(4)-1).eq.' ')) then
	               field3=line2(mpos(4)+2:npos(4)-2)
	               read(field3,*)c(n)
	          else if ((line2(mpos(4)+2:mpos(4)+2).eq.' ').and.
     &           (line2(npos(4)-1:npos(4)-1).ne.' ')) then
	               field3=line2(mpos(4)+2:npos(4)-1)
	               read(field3,*)c(n)
	          else if ((line2(mpos(4)+2:mpos(4)+2).ne.' ').and.
     &           (line2(npos(4)-1:npos(4)-1).eq.' ')) then
	               field3=line2(mpos(4)+2:npos(4)-2)
	               read(field3,*)c(n)
	          else
	            field3=line2(mpos(4)+2:npos(4)-1)
	            read(field3,*)c(n)
	          end if
	         end if

*	         CHECK FOR 4TH COLUMN
	         if (lpos(5).gt.kpos(5)) then
	          if ((line2(mpos(5)+2:mpos(5)+2).eq.' ').and.
     &              (line2(npos(5)-1:npos(5)-1).eq.' ')) then
	               field4=line2(mpos(5)+2:npos(5)-2)
	               read(field4,*)d(n)
	          else if ((line2(mpos(5)+2:mpos(5)+2).eq.' ').and.
     &           (line2(npos(5)-1:npos(5)-1).ne.' ')) then
	               field4=line2(mpos(5)+2:npos(5)-1)
	               read(field4,*)d(n)
	          else if ((line2(mpos(5)+2:mpos(5)+2).ne.' ').and.
     &           (line2(npos(5)-1:npos(5)-1).eq.' ')) then
	               field4=line2(mpos(5)+2:npos(5)-2)
	               read(field4,*)d(n)
	          else
	            field4=line2(mpos(5)+2:npos(5)-1)
	            read(field4,*)d(n)
	          end if
	         end if

*	         WRITE(6,*)FIELD1,FIELD2,FIELD3,FIELD4
*	         WRITE(6,*)A(N),B(N),C(N),D(N)

	         n=n+1
	      end if
	      flag2=flag2+1
	      goto 3

4	   end if

*	   IF (READ_DATA) WRITE(6,*)'Finished reading data block...'

	end if

*	CHECK TO SEE IF REACHED END OF THE DATA ENTRY
	if (.not.read_entry) then
	   ipos=index(line(1:200),'</SASentry>')
	   if (ipos.gt.0) read_entry=.true.
	   if (ipos.gt.0) flag2=flag2+1
	end if

*	IF (READ_ENTRY) WRITE(6,*)'Finished reading an entry...'

*	CHECK TO SEE IF THERE IS ANOTHER DATA BLOCK
	if ((read_data).and.(.not.read_entry)) then
	   ipos=index(line(1:200),'<SASdata')
	   if (ipos.gt.0) next_data=.true.
*	   if (ipos.gt.0) flag2=flag2+1
	end if

*	IF (NEXT_DATA) WRITE(6,*) 'Reading another data block in this entry...'

*	FIND MAX & MIN X VALUES & INTENSITIES
*	if (read_entry) then
	if ((read_entry).or.(next_data)) then
	   n=n-1
	   ymax=-1.E38
	   ymin=1.E38
	   do i=1,n
	      if (b(i).gt.ymax) ymax=b(i)
	      if (b(i).lt.ymin) ymin=b(i)
	   end do

	   xmax=-1.E38
	   xmin=1.E38
	   do i=1,n
	      if (a(i).gt.xmax) xmax=a(i)
	      if (a(i).lt.xmin) xmin=a(i)
	   end do
	end if

*	CHECK TO SEE IF THERE IS ANOTHER ENTRY
	if (read_entry) then
	   read(unit=iunit,fmt=1000,err=6,end=8886)line
*	   WRITE(6,'(i6,a80)')flag2,line(1:80)
	   ipos=index(line(1:200),'<SASentry')
	   if (ipos.gt.0) next_entry=.true.
	   if (ipos.gt.0) flag2=flag2+1
6	end if

*	CHECK TO SEE IF REACHED LAST LINE OF THE FILE
	if (.not.found_endroot) then
	   ipos=index(line(1:200),'</SASroot>')
	   if (ipos.gt.0) found_endroot=.true.
	   if (ipos.gt.0) flag2=flag2+1
	end if

	if (found_endroot) goto 7

*	GO READ ANOTHER ANOTHER LINE FROM THE FILE
	if ((.not.read_entry).and.(.not.next_entry).and.(.not.next_data)) flag2=flag2+1
	if ((.not.read_entry).and.(.not.next_entry).and.(.not.next_data)) goto 1

	goto 8889
*	SUCCESSFUL READ OF FILE
7	flag=0
        goto 8889
*	END OF FILE ENCOUNTERED
8886    flag=-3
	n=0
	goto 8889
*	ERROR DURING READ
8887    flag=-2
	n=0
	goto 8889
*	FILE FORMAT SUSPECT
8888    flag=-1
	n=0

8889    close(unit=iunit)
8890	return
        end

C===============================================================================


