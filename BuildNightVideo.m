clear night;
image=imread('night.jpg');tic;
tic
parfor i=1:200
    night{i} = NightImage(image);
    disp(i);
end
toc

aviobj = avifile('night.avi');
fig = figure;
for i=1:200
    imshow(night{i});
    drawnow;
    %pause(1/40);
    F = getframe(fig);
    aviobj = addframe(aviobj,F);    
end
aviobj = close(aviobj);
