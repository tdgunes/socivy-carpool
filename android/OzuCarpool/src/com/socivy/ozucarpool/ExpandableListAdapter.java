package com.socivy.ozucarpool;


import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.TextView;

public class ExpandableListAdapter extends BaseExpandableListAdapter {

	private static final class ViewHolder {
		TextView textLabel;
	}

	private final List<ParentItem> itemList;
	private final LayoutInflater inflater;

	public ExpandableListAdapter(Context context, List<ParentItem> itemList) {
		this.inflater = LayoutInflater.from(context);
		this.itemList = itemList;
	}

	@Override
	public ChildItem getChild(int groupPosition, int childPosition) {

		return itemList.get(groupPosition).getChildItemList().get(childPosition);
	}

	@Override
	public long getChildId(int groupPosition, int childPosition) {
		return childPosition;
	}

	@Override
	public int getChildrenCount(int groupPosition) {
		return itemList.get(groupPosition).getChildItemList().size();
	}

	@Override
	public View getChildView(int groupPosition, int childPosition, boolean isLastChild, View convertView,
			final ViewGroup parent) {
		View resultView = convertView;
		ViewHolder holder;


		if (resultView == null) {

			resultView = inflater.inflate(R.layout.list_group_item, null); //TODO change layout id
			holder = new ViewHolder();
			holder.textLabel = (TextView) resultView.findViewById(R.id.grp_child); //TODO change view id
			resultView.setTag(holder);
		} else {
			holder = (ViewHolder) resultView.getTag();
		}

		final ChildItem item = getChild(groupPosition, childPosition);

		holder.textLabel.setText(item.toString());

		return resultView;
	}

	@Override
	public ParentItem getGroup(int groupPosition) {
		return itemList.get(groupPosition);
	}

	@Override
	public int getGroupCount() {
		return itemList.size();
	}

	@Override
	public long getGroupId(final int groupPosition) {
		return groupPosition;
	}

	@Override
	public View getGroupView(int groupPosition, boolean isExpanded, View theConvertView, ViewGroup parent) {
		View resultView = theConvertView;
		ViewHolder holder;

		if (resultView == null) {
			resultView = inflater.inflate(R.layout.list_group, null); //TODO change layout id
			holder = new ViewHolder();
			holder.textLabel = (TextView) resultView.findViewById(R.id.row_name); //TODO change view id
			resultView.setTag(holder);
		} else {
			holder = (ViewHolder) resultView.getTag();
		}

		final ParentItem item = getGroup(groupPosition);

		holder.textLabel.setText(item.toString());

		return resultView;
	}

	@Override
	public boolean hasStableIds() {
		return true;
	}

	@Override
	public boolean isChildSelectable(int groupPosition, int childPosition) {
		return true;
	}


}

class ParentItem {

	public String title;
	private List<ChildItem> childItemList;

	public ParentItem(String title) {
		this.title = title;
		childItemList = new ArrayList<ChildItem>();
	}

	public List<ChildItem> getChildItemList() {
		return childItemList;
	}

	public String toString() {
		return title;
	}
}

class ChildItem {

	public String title;
	public ChildItem(String title) {
		this.title = title;
	}
	
	public String toString() {
		return title;
	}
}
