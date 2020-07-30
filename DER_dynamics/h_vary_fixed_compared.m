% V_DER3s_varyh4_EAEI0_la;
% V_DER_h5_YZ_EAEI0_la;

% plot(V_DER3s_varyh4_EAEI0_la(:,2),V_DER3s_varyh4_EAEI0_la(:,3));
% hold on;
% plot(V_DER_h5_YZ_EAEI0_la(:,2),V_DER_h5_YZ_EAEI0_la(:,3));
% hold off;

plot(T,V_DER3s_varyh4_EAEI0_la(:,3));
hold on;
plot(0:1e-5:1.5,V_DER_h5_YZ_EAEI0_la(:,3));
hold off;