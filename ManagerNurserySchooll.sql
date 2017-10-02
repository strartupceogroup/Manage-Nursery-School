create database Manager_Nursery_School;

use Manager_Nursery_School;  
/* Bảng danh mục các loại lớp:
    A = Lớp dành cho trẻ dưới 1 năm tuổi
    B = Lớp dành cho trẻ từ 1 đến 2 năm tuổi
    C = Lớp dành cho trẻ từ 2 đến 3 năm tuổi
    D = Lớp dành cho trẻ từ 3 đến 4 năm tuổi
    E = Lớp dành cho trẻ từ 4 đến 5 năm tuổi */
create table type_class(
	typeClassID varchar(50) not null unique,
    name nvarchar(255) not null unique,
    feeOfYear integer not null,
    constraint pk_type_class primary key(typeClassID)
);

create table class(
	classID varchar(50) not null unique,
    typeClassID varchar(50) not null,
    name nvarchar(255) not null unique,
    -- khóa
    constraint pk_class primary key (classID),
    constraint fk_class_typeClass foreign key (typeClassID) references type_class(typeClassID)
);

create table teacher(
	teacherID varchar(50) not null unique,
    identityCard varchar(20) not null unique, /* CMND */
    name nvarchar(255) not null,
    age int,
    degree varchar(50) not null, /* học vị */
    gender int not null,/* 1=nam, 0=nữ */
    address nvarchar(500) not null,
    phoneNumber varchar(20),
    email varchar(100),
    -- khóa
    constraint pk_teacher primary key (teacherID)
);
	-- Bảng quan hệ giữa bảng class và teacher
	-- Thể hiện việc giáo viên phụ trách lớp học
	create table teacher_of_class(
		classID varchar(50) not null,
        teacherID varchar(50) not null,
        -- khóa
        constraint pk_teacher_of_class primary key(classID, teacherID),
        constraint fk_toc_class foreign key (classID) references class(classID),
        constraint fk_toc_teacher foreign key (teacherID) references teacher(teacherID)
	); 

create table student(
	studentID varchar(50) not null unique,
    name nvarchar(255) not null,
    gender int,
    age int,
    address nvarchar(500) not null,
    phoneNumberOfParent varchar(20), /* số điện thoại của mẹ/bố trẻ */
    nameOfParent nvarchar(255),
    -- khóa
    constraint pk_student primary key(studentID)
);

	-- Bảng quan hệ giữa bảng student và class
    -- Thể hiện việc trẻ thuộc lớp 
    create table student_of_class(
		classID varchar(50) not null,
        studentID varchar(50) not null,
        -- khóa
        constraint pk_student_of_class primary key (classID, studentID),
        constraint fk_soc_class foreign key (classID) references class(classID),
        constraint fk_soc_student foreign key(studentID) references student(studentID)
    );
    
create table tuition_fee(
	tuitionFeeID varchar(50) not null unique,
    /* Thông tin về việc đóng họp phí của trẻ (được lưu dưới dạng json))
		Việc tính học phí do bên t3 (web service soap) tính
        Các thông tin cần thiết cho việc tính toàn học phí gồm
            - Loại lớp đăng ký học (type_class)
            - Số tháng đóng
		-> kết quả trả về là số tiền cần đóng
		
        Thông tin lưu trữ: mã học sinh, ngày đóng, người đóng, mã lớp học
    */
    valueFee varchar(2000) not null,
    constraint pk_tuition_fee primary key (tuitionFeeID)
);

create table user(
	userID varchar(50),
    username varchar(100),
    password varchar(100)
);
