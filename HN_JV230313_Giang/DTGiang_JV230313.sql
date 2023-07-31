create database studentmng;
use studentmng;
create table dmkhoa (
makhoa varchar(20) primary key,
tenkhoa varchar(255)
);
insert into dmkhoa values 
("CNTT","Cong nghe thong tin"),
("KT","Ke toan"),
("SP","Su Pham");
create table dmnganh(
manganh int primary key,
tennganh varchar(255),
makhoa varchar(20) not null,
foreign key (makhoa) references dmkhoa(makhoa)
);
insert into dmnganh(manganh,tennganh,makhoa) values 
(140902,"Su pham toan tin","SP"),
(480202,"Tin hoc ung dung","CNTT");
create table dmlop(
malop varchar(20) primary key,
tenlop varchar(255),
manganh int not null,
khoahoc int,
hedt varchar(255),
namnhaphoc int,
foreign key (manganh) references dmnganh(manganh) 
);
insert into dmlop values 
("CT11","Cao dang tin hoc",480202,11,"TC",2013),
("CT12","Cao dang tin hoc",480202,12,"CD",2013),
("CT13","Cao dang tin hoc",480202,13,"TC",2014);
create table dmhocphan(
mahp int primary key,
tenhp varchar(255),
sodvht int,
manganh int not null,
hocky int,
foreign key (manganh) references dmnganh(manganh)
);
insert into dmhocphan values 
(1,"Toan cao cap A1",4,480202,1),
(2,"Tieng anh 1",3,480202,1),
(3,"Vat ly dai cuong",4,480202,1),
(4,"Tieng anh 2",7,480202,1),
(5,"Tieng anh 1",3,140902,2),
(6,"Xac suat thong ke",3,480202,2);
create table sinhvien(
masv int primary key,
hoten varchar(255),
malop varchar(20) not null,
gioitinh tinyint default 1,
ngaysinh date,
diachi varchar (255),
foreign key (malop) references dmlop(malop)
);
insert into sinhvien values
(1,"Phan Thanh", "CT12",0,"1990-09-12","Tuy Phuoc"),
(2,"Nguyen Thi Cam", "CT12",1,"1994-01-12","Quy Nhon"),
(3,"Vo Thi Ha", "CT12",1,"1990-07-02","An Nhon"),
(4,"Tran Hoai Nam", "CT12",0,"1994-04-05","Tay Son"),
(5,"Tran Van Hoang", "CT13",0,"1995-08-04","Vinh Thanh"),
(6,"Dang Thi Thao", "CT13",1,"1995-06-12","Quy Nhon"),
(7,"Le Thi Sen", "CT13",1,"1994-08-12","Phu My"),
(8,"Nguyen Van Huy", "CT11",0,"1995-06-04","Tuy Phuoc"),
(9,"Tran Thi Hoa", "CT11",1,"1994-08-09","Hoai Nhon");
create table diemhp(
masv int not null,
mahp int not null,
diemhp float,
foreign key (masv) references sinhvien(masv),
foreign key (mahp) references dmhocphan(mahp)
);
insert into diemhp values 
(2,2,5.9),
(2,3,4.5),
(3,1,4.3),
(3,2,6.7),
(3,3,7.3),
(4,1,4),
(4,2,5.2),
(4,3,3.5),
(5,1,9.8),
(5,2,7.9),
(5,3,7.5),
(6,1,6.1),
(6,2,5.6),
(6,3,4),
(7,1,6.2);


-- 1
select sv.masv,sv.hoten,sv.malop,dhp.diemhp,dhp.mahp 
from sinhvien sv
 join diemhp dhp on sv.masv=dhp.masv where diemhp >= 5;
 
 -- 2
 select sv.masv,sv.hoten,sv.malop,dhp.diemhp,dhp.mahp 
from sinhvien sv
 join diemhp dhp on sv.masv=dhp.masv order by sv.malop, sv.hoten;
 
 -- 3
 select sv.masv,sv.hoten,sv.malop,dhp.diemhp,dmhp.hocky 
from sinhvien sv
 join diemhp dhp on sv.masv=dhp.masv
 join dmhocphan dmhp on dmhp.mahp = dhp.mahp
 where diemhp between 5 and 7 and dmhp.hocky = 1;

-- 4
select sv.masv,sv.hoten,sv.malop,lop.tenlop,dmn.makhoa
from sinhvien sv
 join dmlop lop on sv.malop = lop.malop
 join dmnganh dmn on dmn.manganh = lop.manganh 
 join dmkhoa dmk on dmk.makhoa = dmn.makhoa where dmn.makhoa ="CNTT";
 
 -- 5
 select lop.malop, lop.tenlop, count(sv.malop) as SiSo from dmlop lop
 join sinhvien sv on  sv.malop = lop.malop
 group by lop.malop;
 
 -- 6 
 select dmhp.hocky,sv.masv, (sum(dhp.diemhp * dmhp.sodvht)/sum(dmhp.sodvht)) as DiemTBC
 from dmhocphan dmhp 
  join diemhp dhp on dhp.mahp = dmhp.mahp
 join sinhvien sv on sv.masv = dhp.masv
group by sv.masv,dmhp.hocky order by sv.masv;

-- 7
select lop.malop, lop.tenlop,
case when sv.gioitinh = 0 then "Nam" else "Nu" end GioiTinh

, count(sv.malop) as Soluong from dmlop lop
 join sinhvien sv on  sv.malop = lop.malop

 group by lop.malop,sv.gioitinh;
 
 -- 8
  select sv.masv, (sum(dhp.diemhp * dmhp.sodvht)/sum(dmhp.sodvht)) as DiemTBC
 from dmhocphan dmhp 
  join diemhp dhp on dhp.mahp = dmhp.mahp
 join sinhvien sv on sv.masv = dhp.masv
group by sv.masv order by sv.masv;

-- 9
select sv.masv,sv.hoten, count(dhp.diemhp) as SoLuong from sinhvien sv
 join diemhp dhp on dhp.masv = sv.masv where dhp.diemhp <5
group by sv.masv;

-- 10 
select mahp,count(mahp) as SL_SV_Thieu from diemhp where diemhp <5 group by mahp;

-- 11
select sv.masv,sv.hoten mahp,sum(dmhp.sodvht) as Tongdvht from diemhp dhp
join sinhvien sv on sv.masv = dhp.masv
join dmhocphan dmhp on dmhp.mahp = dhp.mahp
 where diemhp <5 group by sv.masv;

-- 12
  select lop.malop, lop.tenlop, count(sv.malop) as SiSo from dmlop lop
 join sinhvien sv on  sv.malop = lop.malop
 group by lop.malop,lop.tenlop having  count(sv.malop) >2;
 
 -- 13 
 select sv.masv,sv.hoten, count(mahp) as SoLuong from diemhp 
 join sinhvien sv on diemhp.masv = sv.masv
 where diemhp <5 group by sv.masv
 having count(mahp)>=2;
 
 -- 14 
  select sv.masv,sv.hoten, count(mahp) as SoLuong from diemhp 
 join sinhvien sv on diemhp.masv = sv.masv where mahp = 1 or 2 or 3 group by sv.masv
 having count(mahp)>=3;
 
 
 